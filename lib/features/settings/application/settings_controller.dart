import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/settings_repository.dart';

class SettingsState {
  final double intervalSeconds;
  final bool soundEnabled;
  final bool isLoading;

  const SettingsState({
    required this.intervalSeconds,
    required this.soundEnabled,
    this.isLoading = false,
  });

  SettingsState copyWith({
    double? intervalSeconds,
    bool? soundEnabled,
    bool? isLoading,
  }) {
    return SettingsState(
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
            intervalSeconds: 1.0,
            soundEnabled: true,
            isLoading: true,
          ),
        ) {
    _load();
  }

  final SettingsRepository _repository;

  Future<void> _load() async {
    final storedInterval = await _repository.getIntervalSeconds();
    final storedSoundEnabled = await _repository.getSoundEnabled();
    state = state.copyWith(
      intervalSeconds: storedInterval ?? state.intervalSeconds,
      soundEnabled: storedSoundEnabled,
      isLoading: false,
    );
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
