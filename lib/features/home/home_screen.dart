import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/theme/app_theme.dart';
import '../detection/application/detection_controller.dart';
import '../detection/presentation/detection_screen.dart';
import '../learn/presentation/learn_screen.dart';
import '../settings/presentation/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _index = 0;
  final bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    // Do not auto-start detection. User should control start/stop from UI.
  }

  void _handleTabChange(int newIndex) {
    final detection = ref.read(detectionControllerProvider.notifier);

    // Stop camera + detection when leaving the Detection tab.
    if (_index == 0 && newIndex != 0) {
      detection.stop();
    }

    setState(() {
      _index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final pages = [
      const DetectionScreen(),
      const LearnScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(
          l10n.appName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              final notifier = ref.read(localeProvider.notifier);
              final current = ref.read(localeProvider);
              if (current?.languageCode == 'en') {
                notifier.setArabic();
              } else {
                notifier.setEnglish();
              }
            },
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: pages[_index],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.9),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BottomNavigationBar(
            currentIndex: _index,
            onTap: _handleTabChange,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.camera_alt_outlined),
                label: l10n.detection,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.menu_book_outlined),
                label: l10n.learn,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings_outlined),
                label: l10n.settings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
