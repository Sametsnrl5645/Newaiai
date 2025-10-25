// lib/main.dart (GÜNCELLEME)
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:newai_project/firebase_options.dart'; // Firebase yapılandırması
import 'package:newai_project/screens/auth/auth_wrapper.dart';
import 'package:newai_project/services/stt_service.dart';
import 'package:newai_project/services/tts_service.dart';
import 'package:newai_project/services/command_processor.dart';
import 'package:newai_project/utils/volume_manager.dart'; // Yeni eklendi
import 'package:newai_project/utils/app_settings_manager.dart'; // Yeni eklendi

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter'ı başlat
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  // Tüm servisleri burada başlat
  await NewaiTextToSpeech.initialize();
  await NewaiSpeechToText.initialize();
  await NewaiCommandProcessor.loadCommands();
  await NewaiVolumeManager.initialize(); // Yeni eklendi
  // AppSettingsManager'ın özel bir başlatma metoduna ihtiyacı yok

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Newai Asistan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.grey[900], // Koyu tema
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[900],
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white),
        )
      ),
      home: AuthWrapper(), // Uygulamanın başlangıç noktası AuthWrapper olacak
    );
  }
}