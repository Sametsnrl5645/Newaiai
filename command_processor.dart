// lib/services/command_processor.dart (GÜNCELLEME)
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart'; // kDebugMode için
import 'package:newai_project/services/tts_service.dart';
import 'package:newai_project/utils/external_app_launcher.dart'; // Yeni eklendi
import 'package:newai_project/utils/volume_manager.dart'; // Yeni eklendi
import 'package:newai_project/utils/app_settings_manager.dart'; // Yeni eklendi

class NewaiCommandProcessor {
  static List<Map<String, dynamic>>? _commands;

  static Future<void> loadCommands() async {
    try {
      final String response = await rootBundle.loadString('ekoset/EKOSet_ACCESS_COMMANDS.json');
      final data = await json.decode(response);
      _commands = List<Map<String, dynamic>>.from(data['commands']);
      if (kDebugMode) {
        print('Newai EKOSet komutları başarıyla yüklendi.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Hata: EKOSet komutları yüklenemedi: $e');
      }
    }
  }

  // Komutları işleyen ana fonksiyon
  static Future<void> processCommand(String command) async {
    if (_commands == null) {
      if (kDebugMode) print('Komutlar yüklenmedi.');
      return;
    }

    // Komutu küçük harfe çevirerek karşılaştır
    final lowerCaseCommand = command.toLowerCase();

    for (var cmd in _commands!) {
      List<String> triggers = List<String>.from(cmd['triggers']);
      if (triggers.any((trigger) => lowerCaseCommand.contains(trigger.toLowerCase()))) {
        
        // TTS ile yanıt ver
        String responseText = cmd['response_text'] ?? 'Komutunuz anlaşıldı.';
        if (cmd['is_dynamic'] == true) {
          // Dinamik yanıtlar için
          if (responseText.contains('\${DateTime.now()}')) {
            responseText = 'Şu an saat ${DateTime.now().hour}:${DateTime.now().minute}.';
          }
          // Diğer dinamik yanıtlar buraya eklenebilir
        }
        if (cmd['tts_response'] != null) {
          responseText = cmd['tts_response']; // Eğer özel bir tts_response varsa onu kullan
        }
        await NewaiTextToSpeech.speak(responseText);

        // Aksiyonu gerçekleştir
        if (cmd['action'] == 'dart_call' && cmd['dart_function_name'] != null) {
          await _executeDartFunction(cmd['dart_function_name'], cmd['utility_id']);
        }
        return; // Komut işlendi, diğer komutlara bakmaya gerek yok
      }
    }

    // Hiçbir komut eşleşmezse
    await NewaiTextToSpeech.speak('Üzgünüm, komutunuzu anlayamadım.');
  }

  // Dart fonksiyonlarını utility_id'ye göre çağıran özel metot
  static Future<void> _executeDartFunction(String functionName, String? utilityId) async {
    switch (utilityId) {
      case 'volume_manager':
        if (functionName == 'raiseMediaVolume') {
          await NewaiVolumeManager.raiseMediaVolume();
        } else if (functionName == 'lowerMediaVolume') {
          await NewaiVolumeManager.lowerMediaVolume();
        }
        break;
      case 'external_app_launcher':
        if (functionName == 'launchLarkPlayer') {
          await ExternalAppLauncher.launchLarkPlayer();
        }
        // Diğer uygulamaları başlatmak için buraya yeni if/else ekleyebilirsiniz
        // if (functionName == 'launchOtherApp') { await ExternalAppLauncher.launchApp('com.otherapp.package'); }
        break;
      case 'app_settings_manager':
        if (functionName == 'openWifiSettings') {
          await NewaiAppSettingsManager.openWifiSettings();
        } else if (functionName == 'openBluetoothSettings') {
          await NewaiAppSettingsManager.openBluetoothSettings();
        } else if (functionName == 'openLocationSettings') {
          await NewaiAppSettingsManager.openLocationSettings();
        }
        break;
      default:
        if (kDebugMode) print('Bilinmeyen utility_id veya fonksiyon: $functionName');
        break;
    }
  }
}