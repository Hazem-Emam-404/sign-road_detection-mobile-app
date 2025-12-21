import 'dart:async';
import 'dart:typed_data';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../features/settings/application/settings_controller.dart';

class AudioService {
  AudioService._internal();

  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  final _player = AudioPlayer();

  Future<void> playDetectionTone(Ref? ref) async {
    // Check if sound is enabled in settings
    if (ref != null) {
      final settings = ref.read(settingsControllerProvider);
      if (!settings.soundEnabled) {
        return; // Sound disabled, don't play
      }
    }

    try {
      // Stop any currently playing sound first
      try {
        if (_player.playing) {
          await _player.stop();
        }
      } catch (_) {
        // Ignore if nothing is playing
      }

      // Generate urgent warning sound: double beep pattern
      final warningBytes = _generateWarningSound();
      final dataUri = Uri.dataFromBytes(warningBytes, mimeType: 'audio/wav');

      // Use setUrl with data URI
      await _player.setUrl(dataUri.toString());
      // Small delay to ensure player is ready
      await Future.delayed(const Duration(milliseconds: 50));
      await _player.play();
      // Don't wait - let it play in background
    } catch (_) {
      // Fallback 1: Try system sound
      try {
        await SystemSound.play(SystemSoundType.alert);
      } catch (_) {
        // Fallback 2: Use haptic feedback pattern
        try {
          await HapticFeedback.heavyImpact();
          await Future.delayed(const Duration(milliseconds: 80));
          await HapticFeedback.mediumImpact();
          await Future.delayed(const Duration(milliseconds: 50));
          await HapticFeedback.lightImpact();
        } catch (_) {
          // Last resort: single haptic
          try {
            await HapticFeedback.heavyImpact();
          } catch (_) {
            // Ignore if all fail
          }
        }
      }
    }
  }

  // Generate a simple beep sound (WAV format)
  Uint8List _generateBeepSound(int frequency, int durationMs) {
    const sampleRate = 44100;
    final numSamples = (sampleRate * durationMs / 1000).round();
    final samples = Float32List(numSamples * 2); // Stereo

    for (int i = 0; i < numSamples; i++) {
      final t = i / sampleRate;
      final sample = math.sin(2 * math.pi * frequency * t);
      // Apply envelope to avoid clicks
      final envelope = i < numSamples * 0.1
          ? i / (numSamples * 0.1)
          : (i > numSamples * 0.9)
              ? (numSamples - i) / (numSamples * 0.1)
              : 1.0;
      // Increase base amplitude for a louder beep
      final value = (sample * envelope * 0.6).clamp(-1.0, 1.0);
      samples[i * 2] = value; // Left channel
      samples[i * 2 + 1] = value; // Right channel
    }

    // Convert to 16-bit PCM
    final pcmData = Int16List(numSamples * 2);
    for (int i = 0; i < samples.length; i++) {
      pcmData[i] = (samples[i] * 32767).round().clamp(-32768, 32767);
    }

    // Create WAV file header
    final header = ByteData(44);
    header.setUint8(0, 0x52); // 'R'
    header.setUint8(1, 0x49); // 'I'
    header.setUint8(2, 0x46); // 'F'
    header.setUint8(3, 0x46); // 'F'
    header.setUint32(
        4, 36 + pcmData.length * 2, Endian.little); // File size - 8
    header.setUint8(8, 0x57); // 'W'
    header.setUint8(9, 0x41); // 'A'
    header.setUint8(10, 0x56); // 'V'
    header.setUint8(11, 0x45); // 'E'
    header.setUint8(12, 0x66); // 'f'
    header.setUint8(13, 0x6D); // 'm'
    header.setUint8(14, 0x74); // 't'
    header.setUint8(15, 0x20); // ' '
    header.setUint32(16, 16, Endian.little); // Subchunk1Size
    header.setUint16(20, 1, Endian.little); // AudioFormat (PCM)
    header.setUint16(22, 2, Endian.little); // NumChannels (Stereo)
    header.setUint32(24, sampleRate, Endian.little); // SampleRate
    header.setUint32(28, sampleRate * 2 * 2, Endian.little); // ByteRate
    header.setUint16(32, 4, Endian.little); // BlockAlign
    header.setUint16(34, 16, Endian.little); // BitsPerSample
    header.setUint8(36, 0x64); // 'd'
    header.setUint8(37, 0x61); // 'a'
    header.setUint8(38, 0x74); // 't'
    header.setUint8(39, 0x61); // 'a'
    header.setUint32(40, pcmData.length * 2, Endian.little); // Subchunk2Size

    // Combine header and PCM data
    final wavBytes = Uint8List(44 + pcmData.length * 2);
    wavBytes.setRange(0, 44, header.buffer.asUint8List());
    for (int i = 0; i < pcmData.length; i++) {
      wavBytes[44 + i * 2] = pcmData[i] & 0xFF;
      wavBytes[44 + i * 2 + 1] = (pcmData[i] >> 8) & 0xFF;
    }

    return wavBytes;
  }

  // Generate urgent warning sound: triple beep pattern (more alarming)
  Uint8List _generateWarningSound() {
    const sampleRate = 44100;
    const beepDuration = 120; // ms - shorter, more urgent
    const pauseDuration = 60; // ms - shorter pause, more rapid
    // Triple beep: low-high-higher pattern
    const totalDuration = (beepDuration * 3) + (pauseDuration * 2);
    final numSamples = (sampleRate * totalDuration / 1000).round();
    final samples = Float32List(numSamples * 2); // Stereo

    int sampleIndex = 0;

    // Helper function to generate a beep
    void addBeep(int frequency, int durationMs, double volume) {
      final beepSamples = (sampleRate * durationMs / 1000).round();
      for (int i = 0; i < beepSamples; i++) {
        final t = i / sampleRate;
        // Add harmonics for more piercing sound
        final fundamental = math.sin(2 * math.pi * frequency * t);
        final harmonic = math.sin(2 * math.pi * frequency * 2 * t) * 0.3;
        final sample = fundamental + harmonic;

        // Sharp attack, quick decay for urgency
        final envelope = i < beepSamples * 0.05
            ? i / (beepSamples * 0.05) // Very fast attack
            : (i > beepSamples * 0.7)
                ? (beepSamples - i) / (beepSamples * 0.3) // Quick decay
                : 1.0;

        final value = (sample * envelope * volume).clamp(-1.0, 1.0);
        samples[sampleIndex * 2] = value;
        samples[sampleIndex * 2 + 1] = value;
        sampleIndex++;
      }
    }

    void addPause(int durationMs) {
      final pauseSamples = (sampleRate * durationMs / 1000).round();
      for (int i = 0; i < pauseSamples; i++) {
        samples[sampleIndex * 2] = 0.0;
        samples[sampleIndex * 2 + 1] = 0.0;
        sampleIndex++;
      }
    }

    // Triple beep pattern: escalating frequencies and increased volume
    addBeep(1200, beepDuration, 0.9); // First beep: high frequency (loud)
    addPause(pauseDuration);
    addBeep(1500, beepDuration, 0.95); // Second beep: higher, louder
    addPause(pauseDuration);
    addBeep(
        1800, beepDuration, 1.0); // Third beep: highest, loudest - most urgent

    // Convert to 16-bit PCM
    final pcmData = Int16List(numSamples * 2);
    for (int i = 0; i < samples.length; i++) {
      pcmData[i] = (samples[i] * 32767).round().clamp(-32768, 32767);
    }

    // Create WAV file header
    final header = ByteData(44);
    header.setUint8(0, 0x52); // 'R'
    header.setUint8(1, 0x49); // 'I'
    header.setUint8(2, 0x46); // 'F'
    header.setUint8(3, 0x46); // 'F'
    header.setUint32(4, 36 + pcmData.length * 2, Endian.little);
    header.setUint8(8, 0x57); // 'W'
    header.setUint8(9, 0x41); // 'A'
    header.setUint8(10, 0x56); // 'V'
    header.setUint8(11, 0x45); // 'E'
    header.setUint8(12, 0x66); // 'f'
    header.setUint8(13, 0x6D); // 'm'
    header.setUint8(14, 0x74); // 't'
    header.setUint8(15, 0x20); // ' '
    header.setUint32(16, 16, Endian.little);
    header.setUint16(20, 1, Endian.little);
    header.setUint16(22, 2, Endian.little);
    header.setUint32(24, sampleRate, Endian.little);
    header.setUint32(28, sampleRate * 2 * 2, Endian.little);
    header.setUint16(32, 4, Endian.little);
    header.setUint16(34, 16, Endian.little);
    header.setUint8(36, 0x64); // 'd'
    header.setUint8(37, 0x61); // 'a'
    header.setUint8(38, 0x74); // 't'
    header.setUint8(39, 0x61); // 'a'
    header.setUint32(40, pcmData.length * 2, Endian.little);

    // Combine header and PCM data
    final wavBytes = Uint8List(44 + pcmData.length * 2);
    wavBytes.setRange(0, 44, header.buffer.asUint8List());
    for (int i = 0; i < pcmData.length; i++) {
      wavBytes[44 + i * 2] = pcmData[i] & 0xFF;
      wavBytes[44 + i * 2 + 1] = (pcmData[i] >> 8) & 0xFF;
    }

    return wavBytes;
  }
}
