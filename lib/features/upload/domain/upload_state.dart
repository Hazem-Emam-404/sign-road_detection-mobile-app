import 'dart:io';

class UploadState {
  final File? selectedImage;
  final bool isProcessing;
  final String? resultLabel;
  final double? confidence;
  final String? error;

  const UploadState({
    this.selectedImage,
    this.isProcessing = false,
    this.resultLabel,
    this.confidence,
    this.error,
  });

  factory UploadState.initial() => const UploadState();

  UploadState copyWith({
    File? selectedImage,
    bool? isProcessing,
    String? resultLabel,
    double? confidence,
    String? error,
    bool clearResult = false,
  }) {
    return UploadState(
      selectedImage: selectedImage ?? this.selectedImage,
      isProcessing: isProcessing ?? this.isProcessing,
      resultLabel: clearResult ? null : (resultLabel ?? this.resultLabel),
      confidence: clearResult ? null : (confidence ?? this.confidence),
      error: clearResult ? null : (error ?? this.error),
    );
  }
}
