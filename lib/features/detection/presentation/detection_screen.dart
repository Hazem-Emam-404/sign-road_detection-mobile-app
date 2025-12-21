import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../settings/application/settings_controller.dart';
import '../application/detection_controller.dart';

class DetectionScreen extends ConsumerStatefulWidget {
  const DetectionScreen({super.key});

  @override
  ConsumerState<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends ConsumerState<DetectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final detection = ref.watch(detectionControllerProvider);
    final settings = ref.watch(settingsControllerProvider);

    final controller = detection.controller;

    if (!detection.isInitialized || controller == null) {
      return Center(
        child: Shimmer.fromColors(
          baseColor: Colors.white10,
          highlightColor: Colors.white24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 160,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (detection.error != null) {
      final errorText = detection.error == '__SERVER_UNAVAILABLE__'
          ? l10n.serverUnavailable
          : detection.error!;
      return Center(
        child: GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded, color: Colors.redAccent),
              const SizedBox(height: 12),
              Text(
                l10n.connectionFailed,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                errorText,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.white54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(detectionControllerProvider.notifier).start();
                },
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    final showOverlay = detection.currentSign != 'no_sign';
    final showWarning = detection.currentSign != 'no_sign';

    return Stack(
      children: [
        Positioned.fill(
          child: CameraPreview(controller),
        ),
        // Flashing red warning border around camera frame edges when sign detected
        if (showWarning)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red.withOpacity(
                          _pulseAnimation.value * 0.6, // Reduced from 1.0
                        ),
                        width: 5, // Reduced from 10
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red.withOpacity(
                            _pulseAnimation.value * 0.4, // Reduced from 0.7
                          ),
                          width: 3, // Reduced from 6
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        Positioned(
          top: 32,
          left: 16,
          child: GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.speed, size: 18, color: Colors.white70),
                const SizedBox(width: 6),
                Text(
                  'FPS: ${detection.fps.toStringAsFixed(1)} · '
                  '${settings.intervalSeconds.toStringAsFixed(1)}s',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 28,
          right: 16,
          child: GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                // Uploading spinner: only show while running and awaiting response
                if (detection.isUploading && detection.isRunning) ...[
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation(Colors.tealAccent),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                // Single toggle button (play / pause) with label
                IconButton(
                  tooltip: detection.isRunning
                      ? 'Stop real-time'
                      : 'Start real-time',
                  onPressed: () {
                    final ctrl = ref.read(detectionControllerProvider.notifier);
                    if (detection.isRunning) {
                      ctrl.stop();
                    } else {
                      ctrl.start();
                    }
                  },
                  icon: Icon(detection.isRunning
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded),
                  color: detection.isRunning
                      ? Colors.orangeAccent
                      : AppColors.primaryTeal,
                ),
                const SizedBox(width: 6),
                Text(
                  detection.isRunning
                      ? 'Realtime: Running'
                      : 'Realtime: Stopped',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
        if (showOverlay)
          // Positioned bottom center above bottom navigation bar
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).padding.bottom + 72,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Center(
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const RadialGradient(
                              colors: [Colors.redAccent, Colors.red],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red
                                    .withOpacity(_pulseAnimation.value * 0.6),
                                blurRadius: 14,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.warning_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Allow label to wrap and expand the card height when needed
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detection.currentSign.toUpperCase(),
                                softWrap: true,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.redAccent,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              if (detection.confidence != null)
                                Text(
                                  // show confidence as percentage with 2 decimals
                                  'Confidence: ${((detection.confidence! * 100)).toStringAsFixed(2)}%',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.white70),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
