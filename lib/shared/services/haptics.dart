import 'package:flutter/services.dart';

class Haptics {
  static Future<void> lightImpact() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (_) {
      // Ignore haptics errors.
    }
  }
}
