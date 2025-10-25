// lib/utils/app_settings_manager.dart
import 'package:open_settings_plus/open_settings_plus.dart';
import 'package:flutter/foundation.dart';

class NewaiAppSettingsManager {
  static final OpenSettingsPlus _settings = OpenSettingsPlus.flash;

  // WiFi Ayarlarını açar
  static Future<void> openWifiSettings() async {
    try {
      await _settings.wifi();
      if (kDebugMode) print('WiFi ayarları açıldı.');
    } catch (e) {
      if (kDebugMode) print('WiFi ayarları açılamadı: $e');
    }
  }

  // Bluetooth Ayarlarını açar
  static Future<void> openBluetoothSettings() async {
    try {
      await _settings.bluetooth();
      if (kDebugMode) print('Bluetooth ayarları açıldı.');
    } catch (e) {
      if (kDebugMode) print('Bluetooth ayarları açılamadı: $e');
    }
  }
  
  // Konum (GPS) Ayarlarını açar
  static Future<void> openLocationSettings() async {
    try {
      await _settings.location();
      if (kDebugMode) print('Konum ayarları açıldı.');
    } catch (e) {
      if (kDebugMode) print('Konum ayarları açılamadı: $e');
    }
  }
}