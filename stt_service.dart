// lib/services/stt_service.dart
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/foundation.dart';

class NewaiSpeechToText {
  static final stt.SpeechToText _speech = stt.SpeechToText();
  static bool _isListening = false;
  static bool get isListening => _isListening;
  
  // Uygulama açılışında STT servisini başlatır
  static Future<void> initialize() async {
    // İzinleri kontrol eder ve başlatır
    bool available = await _speech.initialize(
      onError: (val) => _handleError(val, 'STT Hata:'),
      onStatus: (val) => _handleStatus(val),
    );
    if (kDebugMode) {
      print('STT başlatma durumu: $available');
    }
  }

  // Dinlemeyi başlatır
  static Future<void> startListening({
    required Function(String) onResult,
    Duration listenFor = const Duration(hours: 1),
    Duration pauseFor = const Duration(seconds: 3),
  }) async {
    if (!_speech.isAvailable) {
      if (kDebugMode) print('Hata: STT servisi hazır değil.');
      return;
    }
    _isListening = true;

    // Sürekli dinlemeyi başlatan fonksiyon
    await _speech.listen(
      onResult: (val) {
        if (val.recognizedWords.isNotEmpty && val.finalResult) {
          onResult(val.recognizedWords);
          if (kDebugMode) print('STT Algılanan: ${val.recognizedWords}');
        }
      },
      listenFor: listenFor, // Maksimum dinleme süresi (1 saat)
      pauseFor: pauseFor,   // Duraksamadan sonraki bekleme süresi
      localeId: 'tr_TR',     // Türkçe dilini kullan
    );
    _isListening = _speech.isListening;
  }

  // Dinlemeyi durdurur
  static Future<void> stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
      _isListening = false;
      if (kDebugMode) print('STT Durduruldu.');
    }
  }

  // Hata durumlarını yönetir
  static void _handleError(stt.SpeechRecognitionError error, String prefix) {
    if (kDebugMode) {
      print('$prefix ${error.errorMsg} - Kalıcı: ${error.permanent}');
    }
    _isListening = false;
  }

  // Durum değişimlerini yönetir
  static void _handleStatus(String status) {
    if (kDebugMode) {
      print('STT Durumu: $status');
    }
    if (status == stt.SpeechToText.listeningStatus) {
      _isListening = true;
    } else if (status == stt.SpeechToText.doneStatus) {
      _isListening = false;
      // Dinleme bittiğinde (örn: 3 saniye sessizlikten sonra) tekrar başlatma logic'i
      // CommandProcessor.dart veya HomeScreen'de yönetilir.
    }
  }
}