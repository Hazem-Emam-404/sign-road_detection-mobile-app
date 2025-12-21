import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/locale_provider.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../shared/services/haptics.dart';
import '../../../shared/widgets/glass_card.dart';
import '../data/signs_data.dart';
import 'sign_detail_sheet.dart';

class LearnScreen extends ConsumerWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isArabic = ref.watch(localeProvider)?.languageCode == 'ar';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.learnSigns,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: signs.length,
              itemBuilder: (context, index) {
                final sign = signs[index];
                return SignCard(
                  sign: sign,
                  isArabic: isArabic,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SignCard extends StatefulWidget {
  const SignCard({super.key, required this.sign, required this.isArabic});

  final dynamic sign;
  final bool isArabic;

  @override
  State<SignCard> createState() => _SignCardState();
}

class _SignCardState extends State<SignCard>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sign = widget.sign;
    final title = widget.isArabic ? sign.nameAr : sign.nameEn;
    final sub = widget.isArabic ? sign.nameEn : sign.nameAr;
    final description =
        widget.isArabic ? sign.descriptionAr : sign.descriptionEn;

    return SizedBox.expand(
      child: GestureDetector(
        onLongPress: () async {
          await Haptics.lightImpact();
          // show full detail sheet on long press
          showGeneralDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel: 'Close sign details',
            barrierColor: Colors.black.withOpacity(0.55),
            transitionDuration: const Duration(milliseconds: 220),
            pageBuilder: (ctx, animation, secondaryAnimation) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(ctx).pop(),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(ctx)) Navigator.pop(ctx);
                    },
                    child: SignDetailSheet(sign: sign),
                  ),
                ),
              );
            },
          );
        },
        child: GlassCard(
          onTap: () async {
            // Single tap opens details (previous behavior)
            await Haptics.lightImpact();
            showGeneralDialog(
              context: context,
              barrierDismissible: true,
              barrierLabel: 'Close sign details',
              barrierColor: Colors.black.withOpacity(0.55),
              transitionDuration: const Duration(milliseconds: 220),
              pageBuilder: (ctx, animation, secondaryAnimation) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(ctx).pop(),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        if (Navigator.canPop(ctx)) Navigator.pop(ctx);
                      },
                      child: SignDetailSheet(sign: sign),
                    ),
                  ),
                );
              },
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Hero(
                  tag: 'sign_${sign.id}',
                  child: Image.asset(
                    sign.imageAsset,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  sub,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
