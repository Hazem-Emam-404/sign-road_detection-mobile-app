import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  TtsService._internal();

  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;

  final _tts = FlutterTts();

  Future<void> speak(String text, {String languageCode = 'en-US'}) async {
    try {
      await _tts.setLanguage(languageCode);
      await _tts.setSpeechRate(0.45);
      await _tts.speak(text);
    } catch (_) {
      // Ignore TTS failures.
    }
  }
}


