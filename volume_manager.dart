// lib/utils/volume_manager.dart
import 'package:volume_controller/volume_controller.dart';
import 'package:flutter/foundation.dart';

class NewaiVolumeManager {
  
  static Future<void> initialize() async {
    if (kDebugMode) print('Ses yöneticisi başlatıldı.');
  }

  // Medya sesini bir adım (örneğin %10) yükseltir
  static Future<void> raiseMediaVolume() async {
    await VolumeController().incrementVolume(0.1, showSystemUI: false);
    if (kDebugMode) print('Medya sesi yükseltildi.');
  }

  // Medya sesini bir adım (örneğin %10) azaltır
  static Future<void> lowerMediaVolume() async {
    await VolumeController().decrementVolume(0.1, showSystemUI: false);
    if (kDebugMode) print('Medya sesi azaltıldı.');
  }
}