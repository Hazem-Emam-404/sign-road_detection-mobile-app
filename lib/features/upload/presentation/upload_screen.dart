
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/constants/sign_translations.dart';
import '../../../shared/widgets/glass_card.dart';
import '../application/upload_controller.dart';

class UploadScreen extends ConsumerWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uploadControllerProvider);
    final controller = ref.read(uploadControllerProvider.notifier);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),
                Expanded(
                  child: GlassCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: state.isProcessing ? null : controller.pickImage,
                            child: _buildImagePreview(context, state),
                          ),
                        ),
                        if (state.isProcessing)
                           const LinearProgressIndicator(
                            color: AppColors.primaryTeal,
                            backgroundColor: Colors.transparent,
                          ),
                        _buildActionArea(context, state, controller),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (state.resultLabel != null) _buildResultCard(context, state),
                if (state.error != null) _buildErrorCard(context, state.error!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Image',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Analyze traffic signs from your gallery',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
        ),
      ],
    );
  }

  Widget _buildImagePreview(BuildContext context, var state) {
    if (state.selectedImage != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            state.selectedImage!,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.transparent,
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 20),
            ),
          ),
        ],
      );
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.5),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: const Icon(
              Icons.add_photo_alternate_rounded,
              size: 48,
              color: AppColors.primaryTeal,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tap to choose image',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildActionArea(
      BuildContext context, var state, var controller) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: (state.selectedImage == null || state.isProcessing)
            ? null
            : controller.analyzeImage,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryTeal,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: state.isProcessing
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
              )
            : const Text(
                'ANALYZE',
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, var state) {
    final label = state.resultLabel ?? 'Unknown';
    final isNoSign = label == 'no_sign';
    final displayLabel = isNoSign
        ? 'No Sign Detected'
        : label.replaceAll('_', ' ').toUpperCase();
    final confidence = (state.confidence ?? 0.0) * 100;
    
    // Arabic translation
    final arabic = signTranslations[label] ?? signTranslations[label.toLowerCase()];

    return GlassCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isNoSign ? Colors.grey.withOpacity(0.2) : AppColors.primaryTeal.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isNoSign ? Icons.close : Icons.check,
                  color: isNoSign ? Colors.grey : AppColors.primaryTeal,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayLabel,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                     if (arabic != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        arabic,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          fontFamily: 'Cairo', // If available, or system font
                        ),
                      ),
                    ],
                    if (!isNoSign) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Confidence: ${confidence.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
    Widget _buildErrorCard(BuildContext context, String error) {
    return GlassCard(
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.errorRed),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(color: AppColors.errorRed),
            ),
          ),
        ],
      ),
    );
  }
}
