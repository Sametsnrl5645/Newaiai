// lib/services/dynamic_command_loader.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/command_model.dart';
import 'package:flutter/foundation.dart'; // print için

class DynamicCommandLoader {
  static Map<String, CommandModel> _loadedCommands = {};

  static Map<String, CommandModel> get loadedCommands => _loadedCommands;

  static Future<void> loadCommands() async {
    try {
      final String response = await rootBundle.loadString('assets/EKOS_ACCESS_COMMANDS.json');
      final Map<String, dynamic> data = json.decode(response);

      _loadedCommands.clear(); // Önceki komutları temizle

      data.forEach((key, value) {
        _loadedCommands[key] = CommandModel.fromJson(key, value);
      });
      if (kDebugMode) {
        print('Newai: EKOS komutları başarıyla yüklendi. Yüklenen komut sayısı: ${_loadedCommands.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Newai: EKOS komutları yüklenirken hata oluştu: $e');
      }
    }
  }

  // Belirli bir komut anahtar kelimesini içeren bir CommandModel bulur.
  // Bu, daha esnek bir komut işleme için kullanılabilir.
  static CommandModel? findCommandByKeyword(String keyword) {
    // Tüm yüklenen komutlar arasında döngü yap ve kodParcasiDart içinde anahtar kelimeyi ara.
    // DİKKAT: Bu basit bir arama. Daha gelişmiş NLP/fuzzy matching gerekebilir.
    final String lowerKeyword = keyword.toLowerCase();
    for (var entry in _loadedCommands.entries) {
      // Eğer komutun tanımında veya kendisinde bu anahtar kelime geçiyorsa...
      if (entry.value.tanim.toLowerCase().contains(lowerKeyword) || entry.key.toLowerCase().contains(lowerKeyword)) {
        return entry.value;
      }
    }
    return null;
  }
}