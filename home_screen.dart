// lib/screens/home_screen.dart (Revize Edilmiş ve Genişletilmiş Arayüz Tasarımı)
import 'package:flutter/material.dart';
import '../services/stt_service.dart';
import '../services/tts_service.dart';
import '../services/command_processor.dart';
import '../utils/newai_constants.dart';
import 'package:wakelock/wakelock.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/foundation.dart'; // kDebugMode için

// Ayarlar Ekranı için import
import 'settings_screen.dart'; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String _lastWords = '';
  String _newaiResponse = 'Dinliyorum... "Hey Neva" ile başlayabilirsiniz.';
  bool _isListening = false;
  bool _isInitialized = false;
  List<String> _conversationHistory = []; // Konuşma geçmişi için
  
  // Mikrofon animasyonu için
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeNewai();

    // Animasyon kontrolcüsü
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Tekrarla ve tersine çevir

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  Future<void> _initializeNewai() async {
    Wakelock.enable(); // Ekranın sürekli açık kalmasını sağla
    // Mikrofon izni STT servisi tarafından yönetilir.

    // Servisler zaten main.dart'ta başlatılıyor, burada sadece UI durumunu ayarla
    setState(() {
      _isInitialized = true;
    });

    _startContinuousListening(); 
  }

  void _onSpeechResult(String result) {
    if (!mounted) return; // Widget dispose edildi ise güncelleme yapma

    setState(() {
      _lastWords = result;
      _conversationHistory.add('Siz: "$result"'); // Geçmişe kullanıcı komutunu ekle
      _newaiResponse = 'Komut işleniyor...';
    });
    
    NewaiCommandProcessor.processCommand(result).then((_) async {
      // Komut işlendikten sonra Newai'nin konuşmasını bekleyebiliriz.
      // Burada Newai'nin gerçek yanıtını _newaiResponse'a atamak daha iyi olurdu,
      // ancak mevcut CommandProcessor doğrudan yanıt metnini döndürmüyor.
      // Şimdilik sadece "Komut işlendi." mesajını ekleyelim ve tekrar dinlemeye geçelim.
      if (!mounted) return;

      // TTS servisinin konuşmayı bitirmesini bekle
      await Future.delayed(const Duration(milliseconds: 500)); // Kısa bir bekleme
      
      setState(() {
        _newaiResponse = 'Komut işlendi. Dinliyorum...';
        // Gerçek Newai yanıtını burada _conversationHistory'ye eklemek için
        // CommandProcessor'dan yanıt metnini almamız gerekir.
        // Şimdilik sadece komutun işlendiğini belirtelim.
      });
      _startContinuousListening(); // Komut işlendikten sonra tekrar dinlemeye başla
    }).catchError((error) {
       if (!mounted) return;
       if (kDebugMode) print("Komut işleme hatası: $error");
       setState(() {
         _newaiResponse = 'Hata oluştu: ${error.toString()}';
         _startContinuousListening();
       });
    });
  }

  void _startContinuousListening() async {
    if (NewaiSpeechToText.isListening) { // Zaten dinlemedeyse tekrar başlatma
      return;
    }
    setState(() {
      _isListening = true;
      _lastWords = ''; 
      _newaiResponse = 'Dinliyorum... "Hey Neva" ile başlayabilirsiniz.';
    });
    bool started = await NewaiSpeechToText.startListening(
      onResult: _onSpeechResult,
      listenFor: const Duration(hours: 1), 
      pauseFor: const Duration(seconds: 3),
    );
    if (!mounted) return;
    setState(() => _isListening = started); // startListening'den dönen değeri kullan
    if (!_isListening) {
      _newaiResponse = 'Dinleme başlatılamadı. Mikrofon iznini kontrol edin.';
    }
  }

  void _stopListening() async {
    if (_isListening) {
      await NewaiSpeechToText.stopListening();
      if (!mounted) return;
      setState(() {
        _isListening = false;
        _newaiResponse = 'Dinleme Durduruldu. Komut bekliyor...';
      });
    }
  }

  @override
  void dispose() {
    Wakelock.disable();
    _stopListening();
    _animationController.dispose(); // Animasyon kontrolcüsünü serbest bırak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: Colors.grey[900],
        body: const Center(
          child: CircularProgressIndicator(color: Colors.blueAccent),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.grey[900], // Koyu arka plan
      appBar: AppBar(
        title: const Text('Newai Asistan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey[900],
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white70),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
        ],
      ),
      body: SafeArea( // Kenar çubukları ve çentiklerden korunma
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2, // Ekranın üst kısmında daha fazla yer
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Mikrofon simgesi ve animasyon
                    ScaleTransition(
                      scale: _isListening ? _pulseAnimation : Tween<double>(begin: 1.0, end: 1.0).animate(_animationController),
                      child: GestureDetector(
                        onTap: _isListening ? _stopListening : _startContinuousListening,
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _isListening
                                  ? [Colors.redAccent, Colors.red[800]!]
                                  : [Colors.blueAccent, Colors.blue[800]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _isListening ? Colors.red.withOpacity(0.6) : Colors.blue.withOpacity(0.4),
                                blurRadius: _isListening ? 40.0 : 15.0,
                                spreadRadius: _isListening ? 15.0 : 5.0,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Icon(
                            _isListening ? Icons.mic : Icons.mic_none,
                            size: 70,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Newai'nin durumu ve yanıtı
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        _newaiResponse,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),