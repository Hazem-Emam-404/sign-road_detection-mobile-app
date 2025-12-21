import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/settings_repository.dart';

class SettingsState {
  final String serverUrl;
  final double intervalSeconds;
  final bool soundEnabled;
  final bool isLoading;

  const SettingsState({
    required this.serverUrl,
    required this.intervalSeconds,
    required this.soundEnabled,
    this.isLoading = false,
  });

  SettingsState copyWith({
    String? serverUrl,
    double? intervalSeconds,
    bool? soundEnabled,
    bool? isLoading,
  }) {
    return SettingsState(
      serverUrl: serverUrl ?? this.serverUrl,
      intervalSeconds: intervalSeconds ?? this.intervalSeconds,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>(
  (ref) => SettingsController(SettingsRepository()),
);

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController(this._repository)
      : super(
          const SettingsState(
            // store base URL (no path); detection will append /detect
            serverUrl: 'http://127.0.0.1:8000',
            intervalSeconds: 1.0,
            soundEnabled: true,
            isLoading: true,
          ),
        ) {
    _load();
  }

  final SettingsRepository _repository;

  Future<void> _load() async {
    final storedUrl = await _repository.getServerUrl();
    final storedInterval = await _repository.getIntervalSeconds();
    final storedSoundEnabled = await _repository.getSoundEnabled();
    state = state.copyWith(
      serverUrl: storedUrl ?? state.serverUrl,
      intervalSeconds: storedInterval ?? state.intervalSeconds,
      soundEnabled: storedSoundEnabled,
      isLoading: false,
    );
  }

  Future<void> updateServerUrl(String url) async {
    state = state.copyWith(serverUrl: url);
    await _repository.setServerUrl(url);
  }

  Future<void> updateInterval(double seconds) async {
    state = state.copyWith(intervalSeconds: seconds);
    await _repository.setIntervalSeconds(seconds);
  }

  Future<void> updateSoundEnabled(bool enabled) async {
    state = state.copyWith(soundEnabled: enabled);
    await _repository.setSoundEnabled(enabled);
  }
}
