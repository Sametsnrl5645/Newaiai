// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart'; // Firebase kimlik doğrulama eklentisi

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Kullanıcı kaydı
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Kullanıcı girişi
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Çıkış yap
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Mevcut kullanıcıyı al
  Stream<User?> get user {
    return _auth.authStateChanges();
  }
}