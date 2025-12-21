import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/services/http_client.dart';
import '../../../shared/widgets/glass_card.dart';
import '../application/settings_controller.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _urlController;
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(settingsControllerProvider);
    _urlController = TextEditingController(text: state.serverUrl);
    _urlController.addListener(() {
      final current = _urlController.text.trim();
      setState(() {
        _dirty = current != (ref.read(settingsControllerProvider).serverUrl);
      });
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.serverUrl,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _urlController,
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'http://192.168.1.100:8000/predict',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.captureInterval,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Slider(
                  min: 0.5,
                  max: 10.0,
                  divisions: 19, // 0.5, 1.0, 1.5, ..., 10.0
                  value: state.intervalSeconds.clamp(0.5, 10.0),
                  label: state.intervalSeconds.toStringAsFixed(1),
                  onChanged: (value) {
                    controller.updateInterval(value);
                  },
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${state.intervalSeconds.toStringAsFixed(1)} s',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sound Alert',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Play sound when sign is detected',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: state.soundEnabled,
                      onChanged: (value) {
                        controller.updateSoundEnabled(value);
                      },
                      activeThumbColor: AppColors.primaryTeal,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        String raw = _urlController.text.trim();
                        if (raw.isEmpty) raw = 'http://127.0.0.1:8000';
                        if (!raw.startsWith(RegExp(r'https?://'))) {
                          raw = 'http://$raw';
                        }
                        String testUrl;
                        try {
                          final parsed = Uri.parse(raw);
                          final origin = parsed.origin;
                          testUrl =
                              Uri.parse(origin).resolve('ping').toString();
                        } catch (_) {
                          testUrl = Uri.parse('http://127.0.0.1:8000')
                              .resolve('ping')
                              .toString();
                        }
                        try {
                          final resp = await HttpClient().dio.get<dynamic>(
                                testUrl,
                                options: Options(
                                  responseType: ResponseType.json,
                                ),
                              );
                          if (resp.statusCode == 200) {
                            messenger.showSnackBar(
                              SnackBar(content: Text(l10n.connectionOk)),
                            );
                          } else if (resp.statusCode != null &&
                              resp.statusCode! >= 500) {
                            messenger.showSnackBar(
                              SnackBar(content: Text(l10n.serverUnavailable)),
                            );
                          } else {
                            messenger.showSnackBar(
                              SnackBar(content: Text(l10n.connectionFailed)),
                            );
                          }
                        } on DioException catch (e) {
                          if (e.response?.statusCode != null &&
                              e.response!.statusCode! >= 500) {
                            messenger.showSnackBar(
                              SnackBar(content: Text(l10n.serverUnavailable)),
                            );
                          } else {
                            messenger.showSnackBar(
                              SnackBar(content: Text(l10n.connectionFailed)),
                            );
                          }
                        } catch (_) {
                          messenger.showSnackBar(
                            SnackBar(content: Text(l10n.connectionFailed)),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.wifi_tethering),
                          const SizedBox(width: 8),
                          Text(l10n.testConnection),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _dirty
                          ? () async {
                              String newUrl = _urlController.text.trim().isEmpty
                                  ? 'http://127.0.0.1:8000'
                                  : _urlController.text.trim();
                              if (!newUrl.startsWith(RegExp(r'https?://'))) {
                                newUrl = 'http://$newUrl';
                              }
                              await controller.updateServerUrl(newUrl);
                              setState(() {
                                _dirty = false;
                                _urlController.text = newUrl;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Saved')),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: Text('Confirm'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
