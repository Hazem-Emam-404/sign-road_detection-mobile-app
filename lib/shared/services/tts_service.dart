import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  TtsService._internal();

  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;

  final _tts = FlutterTts();

  Future<void> speak(String text, {String languageCode = 'en-US'}) async {
    try {
      print('[TTS] Speaking: "$text" in language: $languageCode');
      await _tts.setLanguage(languageCode);
      await _tts.setSpeechRate(0.45);
      final result = await _tts.speak(text);
      print('[TTS] Speak result: $result');
    } catch (e) {
      print('[TTS] ERROR: $e');
      // Re-throw to help identify issues
      rethrow;
    }
  }
}


