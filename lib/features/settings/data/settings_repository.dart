import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const _keyServerUrl = 'server_url';
  static const _keyInterval = 'capture_interval';
  static const _keySoundEnabled = 'sound_enabled';

  Future<String?> getServerUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyServerUrl);
  }

  Future<void> setServerUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyServerUrl, url);
  }

  Future<double?> getIntervalSeconds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyInterval);
  }

  Future<void> setIntervalSeconds(double seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyInterval, seconds);
  }

  Future<bool> getSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keySoundEnabled) ?? true; // Default: enabled
  }

  Future<void> setSoundEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySoundEnabled, enabled);
  }
}
