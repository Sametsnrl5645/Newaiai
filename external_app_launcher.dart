// lib/utils/external_app_launcher.dart
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/foundation.dart';

class ExternalAppLauncher {
  // Paket adı verilen uygulamayı başlatır
  static Future<void> launchApp(String packageName) async {
    try {
      if (kDebugMode) print('Uygulama başlatılıyor: $packageName');
      
      // Uygulamayı başlatmayı dener
      bool isLaunched = await LaunchApp.openApp(
        androidPackageName: packageName,
        // is\'android' eklenmez, sadece Android'i desteklediğimiz varsayılır
        openStore: false, // Uygulama yoksa marketi açma
      );

      if (kDebugMode && isLaunched) {
        print('$packageName başarıyla başlatıldı.');
      } else if (kDebugMode && !isLaunched) {
        print('$packageName başlatılamadı veya cihazda bulunamadı.');
      }
    } catch (e) {
      if (kDebugMode) print('Uygulama başlatma hatası: $e');
    }
  }

  // Örnek: Lark Player'ı başlatır
  static Future<void> launchLarkPlayer() async {
    // Lark Player'ın standart Android paket adıdır.
    // Farklı bir cihazda farklı olabilir.
    await launchApp('com.larkplayer.mp3player'); 
  }
}