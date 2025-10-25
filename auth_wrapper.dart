// lib/screens/auth/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firebase_auth_service.dart';
import '../home_screen.dart';
import 'login_screen.dart';

class AuthWrapper extends StatelessWidget {
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    // Firebase kimlik doğrulama durumundaki değişiklikleri dinler.
    // Kullanıcı giriş yapmışsa HomeScreen'e, yapmamışsa LoginScreen'e yönlendirir.
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // authService.getCurrentUser() yerine bunu kullan
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Firebase bağlantısı beklenirken bir yükleme göstergesi gösterebiliriz.
          return const Scaffold(
            backgroundColor: Colors.grey,
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          // Kullanıcı giriş yapmışsa Ana Ekrana git
          return HomeScreen();
        } else {
          // Kullanıcı giriş yapmamışsa Giriş Ekranına git
          return LoginScreen();
        }
      },
    );
  }
}