import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signguard/shared/services/haptics.dart';

import '../../../shared/services/http_client.dart';
import '../../../shared/services/tts_service.dart';
import '../../settings/application/settings_controller.dart';
import '../domain/upload_state.dart';

final uploadControllerProvider =
    StateNotifierProvider.autoDispose<UploadController, UploadState>(
  (ref) => UploadController(ref),
);

class UploadController extends StateNotifier<UploadState> {
  UploadController(this._ref) : super(UploadState.initial());

  final Ref _ref;
  final _picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (picked != null) {
        state = state.copyWith(
          selectedImage: File(picked.path),
          clearResult: true, // Reset previous results
          error: null,
        );
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to pick image: $e');
    }
  }

  void clearImage() {
    state = UploadState.initial();
  }

  Future<void> analyzeImage() async {
    final image = state.selectedImage;
    if (image == null) return;

    state = state.copyWith(isProcessing: true, error: null);

    try {
      final settings = _ref.read(settingsControllerProvider);
      final dio = HttpClient().dio;
      final bytes = await image.readAsBytes();

      final formData = FormData.fromMap({
        'file': MultipartFileRecreatable.fromBytes(
          bytes,
          filename: 'upload.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      });

      // Resolve URL similar to DetectionController
      String stored = settings.serverUrl;
      if (!stored.startsWith(RegExp(r'https?://'))) {
        stored = 'http://$stored';
      }
      String detectUrl;
      try {
        final parsed = Uri.parse(stored);
        if (parsed.path.trim().isNotEmpty && parsed.path != '/') {
          detectUrl = stored;
        } else {
          detectUrl = parsed.resolve('detect').toString();
        }
      } catch (_) {
        detectUrl = Uri.parse(stored).resolve('detect').toString();
      }
      final finalUrl = _resolveServerUrl(detectUrl);

      final response = await dio.post<dynamic>(finalUrl, data: formData);

      // Parse Result
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

      // Normalize label
      final lower = signLabel.trim().toLowerCase();
      final normalized =
          (lower == 'no sign' || lower == 'no_sign' || lower == 'nosign')
              ? 'no_sign'
              : signLabel;

      state = state.copyWith(
        isProcessing: false,
        resultLabel: normalized,
        confidence: confidence ?? 0.0,
      );

      if (normalized != 'no_sign' && settings.soundEnabled) {
        // Format the sign name for speaking (e.g., "stop" -> "Stop", "speed_limit50" -> "Speed Limit 50")
        Haptics.lightImpact();
        TtsService().speak(
          normalized,
          languageCode: 'en-US',
        );
      }
    } on DioException catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: _parseDioError(e),
      );
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: 'Analysis failed: ${e.toString()}',
      );
    }
  }

  String _parseDioError(DioException e) {
    final status = e.response?.statusCode;
    final isSocketErr = e.error is SocketException ||
        (e.message != null &&
            e.message!.toLowerCase().contains('connection refused'));

    if (isSocketErr) {
      return 'Connection failed. Check server address.';
    } else if (status != null) {
      if (status >= 500) return 'Server unavailable (500).';
      if (status == 404) return 'Endpoint not found (404).';
      return 'Server error ($status).';
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return 'Connection timed out.';
    }
    return 'Network error: ${e.message}';
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
}
