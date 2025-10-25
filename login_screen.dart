// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import '../home_screen.dart'; // Newai'nin Ana Ekranı

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Newai Giriş'),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Image.asset('assets/newai_logo.png', height: 150), // Logonuz için yer tutucu
            SizedBox(height: 30.0),
            Text(
              'Newai\'ye Hoş Geldiniz!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              child: Text('Giriş Yap ve Başla'), // Doğrudan Ana Ekrana geçiş butonu
              onPressed: () {
                // Firebase kimlik doğrulama olmadığı için doğrudan Ana Ekrana yönlendiriyoruz.
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}