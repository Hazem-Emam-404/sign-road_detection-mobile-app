import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/locale_provider.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../shared/models/traffic_sign.dart';
import '../../../shared/services/haptics.dart';
import '../../../shared/services/tts_service.dart';
import '../../../shared/widgets/glass_card.dart';

class SignDetailSheet extends ConsumerWidget {
  const SignDetailSheet({super.key, required this.sign});

  final TrafficSign sign;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = ref.watch(localeProvider)?.languageCode == 'ar';

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 380,
          maxHeight: 520,
        ),
        child: Material(
          color: Colors.transparent,
          child: GlassCard(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: 'sign_${sign.id}',
                    child: Image.asset(
                      sign.imageAsset,
                      height: 140,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isArabic ? sign.nameAr : sign.nameEn,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isArabic ? sign.nameEn : sign.nameAr,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isArabic ? sign.descriptionAr : sign.descriptionEn,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await Haptics.lightImpact();
                      await TtsService().speak(
                        isArabic ? sign.nameAr : sign.nameEn,
                        languageCode: isArabic ? 'ar-SA' : 'en-US',
                      );
                    },
                    icon: const Icon(Icons.volume_up_rounded),
                    label: Text(AppLocalizations.of(context).pronounce),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
