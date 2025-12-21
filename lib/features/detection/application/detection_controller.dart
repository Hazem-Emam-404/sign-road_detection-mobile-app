import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform, SocketException;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/services/audio_service.dart';
import '../../../shared/services/haptics.dart';
import '../../../shared/services/http_client.dart';
import '../../settings/application/settings_controller.dart';
import '../domain/detection_state.dart';

final detectionControllerProvider =
    StateNotifierProvider<DetectionController, DetectionState>(
  (ref) => DetectionController(ref),
);

class DetectionController extends StateNotifier<DetectionState>
    with WidgetsBindingObserver {
  DetectionController(this._ref) : super(DetectionState.initial()) {
    _init();
    WidgetsBinding.instance.addObserver(this);
    // Listen to settings changes so detection keeps working when user updates URL or interval.
    _ref.listen<SettingsState>(
      settingsControllerProvider,
      (previous, next) {
        try {
          final prev = previous;
          final curr = next;
          if (prev == null) return;
          final serverChanged = prev.serverUrl != curr.serverUrl;
          final intervalChanged = prev.intervalSeconds != curr.intervalSeconds;
          if (serverChanged) {
            // Clear transient network errors when user changes server url
            state = state.copyWith(error: null);
          }
          if ((serverChanged || intervalChanged) &&
              state.isRunning &&
              state.isInitialized) {
            // Reschedule timer so new interval or endpoint is applied immediately.
            _scheduleTimer();
          }
        } catch (_) {
          // ignore listener errors
        }
      },
    );
  }

  Future<Response<T>> _postWithFallback<T>(
      Dio dio, String url, Object? data) async {
    try {
      return await dio.post<T>(url, data: data);
    } on DioException catch (e) {
      // If connection failed, try common emulator host mappings.
      final uri = e.requestOptions.uri;
      final host = uri.host;
      final candidates = <String>[];

      // If original is loopback, try emulator loopback hosts first
      if (host == '127.0.0.1' || host == 'localhost') {
        candidates.addAll(['10.0.2.2', '10.0.3.2']);
      }

      // On Android, emulator host mappings are useful fallbacks for many network setups.
      if (Platform.isAndroid) {
        if (!candidates.contains('10.0.2.2')) candidates.add('10.0.2.2');
        if (!candidates.contains('10.0.3.2')) candidates.add('10.0.3.2');
        if (!candidates.contains('127.0.0.1')) candidates.add('127.0.0.1');
      }

      // Try each candidate host (skip original host)
      for (final candidate in candidates) {
        if (candidate == host) continue;
        try {
          final replaced = uri.replace(host: candidate).toString();
          print('[detection] retrying with fallback host -> $replaced');
          final r = await dio.post<T>(replaced, data: data);
          print('[detection] fallback response status=${r.statusCode}');
          return r;
        } catch (e2) {
          print('[detection] fallback to $candidate failed: $e2');
          // continue to next candidate
        }
      }
      rethrow;
    }
  }

  final Ref _ref;
  Timer? _timer;
  int _frameCount = 0;
  DateTime _lastFpsTime = DateTime.now();
  bool _requestInFlight = false;
  bool _shouldAutoStart = false;

  Future<void> _init() async {
    // Avoid re-initializing if the controller is already set up.
    if (state.controller != null && state.isInitialized) {
      return;
    }

    try {
      final cameras = await availableCameras();
      final camera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();
      state = state.copyWith(controller: controller, isInitialized: true);
      // If start() was called before init, begin detection now
      if (_shouldAutoStart) {
        _scheduleTimer();
      }
      // Don't auto-start otherwise - HomeScreen controls when to start
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void start() {
    // Request detection to start. If controller not yet initialized, remember intent
    _shouldAutoStart = true;
    state = state.copyWith(isRunning: true);
    if (state.isInitialized) {
      _scheduleTimer();
    }
  }

  void stop() {
    _shouldAutoStart = false;
    state = state.copyWith(isRunning: false);
    _timer?.cancel();
    _timer = null;
  }

  void _scheduleTimer() {
    _timer?.cancel();
    final settings = _ref.read(settingsControllerProvider);
    final interval = Duration(
      milliseconds: (settings.intervalSeconds * 1000).round(),
    );
    _timer = Timer.periodic(interval, (_) => _captureAndSend());
    // Start detection immediately instead of waiting for first interval
    _captureAndSend();
  }

  Future<void> _captureAndSend() async {
    if (!state.isRunning || !state.isInitialized) return;
    if (_requestInFlight) return;
    final controller = state.controller;
    if (controller == null || controller.value.isTakingPicture) return;

    try {
      _frameCount++;
      final now = DateTime.now();
      final elapsed = now.difference(_lastFpsTime).inMilliseconds;
      if (elapsed >= 1000) {
        final fps = _frameCount * 1000 / elapsed;
        state = state.copyWith(fps: fps);
        _frameCount = 0;
        _lastFpsTime = now;
      }

      final file = await controller.takePicture();
      final bytes = await file.readAsBytes();
      await _sendToServer(bytes);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> _sendToServer(Uint8List bytes) async {
    if (_requestInFlight) return;
    _requestInFlight = true;
    state = state.copyWith(isUploading: true);
    final settings = _ref.read(settingsControllerProvider);
    final dio = HttpClient().dio;

    try {
      print("[detection] preparing to send image to server");
      final formData = FormData.fromMap({
        'file': MultipartFileRecreatable.fromBytes(
          bytes,
          filename: 'frame.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      });

      // Determine detect endpoint:
      // - If stored URL contains a path (e.g. /detect), use it as the endpoint.
      // - If stored URL is a base (no path), append /detect.
      String stored = settings.serverUrl;
      // Ensure scheme exists so Uri.parse works consistently.
      if (!stored.startsWith(RegExp(r'https?://'))) {
        stored = 'http://$stored';
      }
      String detectUrl;
      try {
        final parsed = Uri.parse(stored);
        if (parsed.path.trim().isNotEmpty && parsed.path != '/') {
          // user provided a full endpoint (use as-is)
          detectUrl = stored;
        } else {
          detectUrl = parsed.resolve('detect').toString();
        }
      } catch (_) {
        detectUrl = Uri.parse(stored).resolve('detect').toString();
      }
      final finalUrl = _resolveServerUrl(detectUrl);
      print('[detection] POST -> $finalUrl  payload=${bytes.length} bytes');
      // Try primary URL, with emulator fallbacks on connection refused
      final response = await _postWithFallback(dio, finalUrl, formData);
      print(
          '[detection] response status=${response.statusCode} data=${response.data}');

      // The FastAPI may return misspelled keys. Accept several common variants.
      final data = response.data as Map<String, dynamic>?;
      String? rawLabel;
      dynamic rawConf;
      if (data != null) {
        rawLabel = data['lable']?.toString() ??
            data['label']?.toString() ??
            data['prediction']?.toString() ??
            data['result']?.toString();
        rawConf = data['confidenece'] ??
            data['confidence'] ??
            data['score'] ??
            data['probability'];
      }

      String signLabel = rawLabel ?? 'NO SIGN';
      double? confidence;
      if (rawConf is num) {
        confidence = rawConf.toDouble();
      } else if (rawConf is String) {
        confidence = double.tryParse(rawConf);
      }

      // Normalize label to our internal 'no_sign' token when appropriate
      final lower = signLabel.trim().toLowerCase();
      final normalized =
          (lower == 'no sign' || lower == 'no_sign' || lower == 'nosign')
              ? 'no_sign'
              : signLabel;

      print(
          '[detection] parsed label="$signLabel" normalized="$normalized" confidence=$rawConf');

      final previous = state.currentSign;
      final changed = normalized != previous;

      if (changed || confidence != state.confidence) {
        if (changed) {
          await Haptics.lightImpact();
          final playSound = changed &&
              normalized != 'no_sign' &&
              _ref.read(settingsControllerProvider).soundEnabled;
          if (playSound) {
            await AudioService().playDetectionTone(_ref);
          }
        }

        final isFirst = !state.isFirstDetectionDone && normalized != 'no_sign';

        state = state.copyWith(
          currentSign: normalized,
          lastSign: previous,
          confidence: confidence,
          isFirstDetectionDone: state.isFirstDetectionDone || isFirst,
          error: null,
        );
      }
    } on DioException catch (e) {
      try {
        print('[detection][DioException] message=${e.message}');
        print('[detection][DioException] uri=${e.requestOptions.uri}');
        print(
            '[detection][DioException] responseStatus=${e.response?.statusCode}');
        print('[detection][DioException] responseData=${e.response?.data}');
      } catch (_) {
        print('[detection][DioException] failed printing details');
      }

      final status = e.response?.statusCode;
      final isTimeout = e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout;

      final bool isSocketErr = e.error is SocketException ||
          (e.message != null &&
              e.message!.toLowerCase().contains('connection refused')) ||
          (e.message != null &&
              e.message!.toLowerCase().contains('no route to host'));

      if (isSocketErr) {
        state = state.copyWith(error: 'Connection failed: ${e.message}');
      } else if (status != null) {
        if (status >= 500) {
          // Set a sentinel error which the UI will translate to a friendly message
          state = state.copyWith(error: '__SERVER_UNAVAILABLE__');
        } else if (status == 404) {
          state = state.copyWith(error: 'Endpoint not found (404)');
        } else if (status == 401 || status == 403) {
          state = state.copyWith(error: 'Unauthorized (status $status)');
        } else {
          state = state.copyWith(error: 'Server returned status $status');
        }
      } else if (isTimeout) {
        // Timeouts indicate connectivity issues — surface to the user.
        state = state.copyWith(error: 'Connection timed out');
        print('[detection] request timed out, reporting error to UI');
      } else {
        print('[detection] non-critical dio error: ${e.message}');
        state = state.copyWith(error: 'Network error: ${e.message}');
      }
      return;
      return;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      print('[detection][error] $e');
    } finally {
      _requestInFlight = false;
      state = state.copyWith(isUploading: false);
    }
  }

  String _resolveServerUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final host = uri.host;
      if ((host == '127.0.0.1' || host == 'localhost') && Platform.isAndroid) {
        final replaced = uri.replace(host: '10.0.2.2');
        return replaced.toString();
      }
      return url;
    } catch (_) {
      return url;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState stateLifecycle) {
    final controller = state.controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (stateLifecycle == AppLifecycleState.inactive ||
        stateLifecycle == AppLifecycleState.paused) {
      // Just stop the detection loop; keep the camera controller alive.
      stop();
    } else if (stateLifecycle == AppLifecycleState.resumed) {
      // Do not auto-start detection on resume — keep user's manual control.
      if (!state.isInitialized) {
        _init();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    state.controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
