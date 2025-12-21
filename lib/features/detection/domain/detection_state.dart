import 'package:camera/camera.dart';

class DetectionState {
  final CameraController? controller;
  final bool isInitialized;
  final bool isRunning;
  final String currentSign;
  final String lastSign;
  final double? confidence;
  final double fps;
  final bool isUploading;
  final bool isFirstDetectionDone;
  final String? error;

  const DetectionState({
    required this.controller,
    required this.isInitialized,
    required this.isRunning,
    required this.currentSign,
    required this.lastSign,
    required this.confidence,
    required this.fps,
    required this.isFirstDetectionDone,
    required this.error,
    required this.isUploading
  });

  factory DetectionState.initial() => const DetectionState(
        controller: null,
        isInitialized: false,
        isRunning: false,
        currentSign: 'no_sign',
        lastSign: 'no_sign',
        confidence: null,
        isUploading: false,
        fps: 0,
        isFirstDetectionDone: false,
        error: null,
      );

  DetectionState copyWith({
    CameraController? controller,
    bool? isInitialized,
    bool? isRunning,
    String? currentSign,
    String? lastSign,
    double? confidence,
    double? fps,
    bool? isUploading,
    bool? isFirstDetectionDone,
    String? error,
  }) {
    return DetectionState(
      controller: controller ?? this.controller,
      isInitialized: isInitialized ?? this.isInitialized,
      isRunning: isRunning ?? this.isRunning,
      currentSign: currentSign ?? this.currentSign,
      lastSign: lastSign ?? this.lastSign,
      confidence: confidence ?? this.confidence,
      isUploading: isUploading ?? this.isUploading,
      fps: fps ?? this.fps,
      isFirstDetectionDone: isFirstDetectionDone ?? this.isFirstDetectionDone,
      error: error,
    );
  }
}
