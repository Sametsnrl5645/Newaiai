// lib/services/tts_service.dart
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';

class NewaiTextToSpeech {
  static final FlutterTts _flutterTts = FlutterTts();

  static Future<void> initialize() async {
    // TTS motorunu başlatır ve ayarları yapar
    await _flutterTts.setLanguage("tr-TR");
    await _flutterTts.setSpeechRate(0.55); // Konuşma hızı (0.0 - 1.0)
    await _flutterTts.setVolume(1.0);     // Ses seviyesi
    await _flutterTts.setPitch(1.0);      // Ses tonu (1.0 normal)
    
    if (kDebugMode) {
      print('TTS başlatıldı.');
    }
  }

  // Belirtilen metni seslendirir
  static Future<void> speak(String text) async {
    await _flutterTts.stop(); // Konuşan bir şey varsa durdur
    await _flutterTts.speak(text);
  }

  // Şu anki konuşmayı durdurur
  static Future<void> stop() async {
    await _flutterTts.stop();
  }
}