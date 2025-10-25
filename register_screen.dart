// lib/screens/auth/register_screen.dart (Firebase'siz ve Sadeleştirilmiş)
import 'package:flutter/material.dart';
import '../home_screen.dart'; // Başarılı "kayıt" sonrası yönlendirilecek ana ekran

class RegisterScreen extends StatelessWidget {
  // Bu ekran, LoginScreen'den bir butonla çağrılabilir
  // Şimdilik doğrudan Ana Ekrana geçişi sağlar.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Newai Hesap Oluştur'),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Image.asset('assets/newai_logo.png', height: 150), // Logoyu tekrar ekleyelim
            SizedBox(height: 30.0),
            Text(
              'Yeni Newai Hesabı Oluşturun',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              child: Text('Hesap Oluştur ve Başla'), // Doğrudan Ana Ekrana geçiş butonu
              onPressed: () {
                // Kayıt butonu, doğrudan Ana Ekrana yönlendirir
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
            SizedBox(height: 20.0),
            TextButton(
              onPressed: () {
                // Geri tuşuyla veya bir butonla LoginScreen'e geri dönme
                Navigator.pop(context); // Basitçe önceki ekrana (LoginScreen) döner.
              },
              child: Text('Giriş Ekranına Geri Dön'),
            )
          ],
        ),
      ),
    );
  }
}