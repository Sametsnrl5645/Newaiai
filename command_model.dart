// lib/models/command_model.dart
class CommandModel {
  final String key; // Komutun benzersiz anahtarı (örn: "HEY_NEVA_ACCESS")
  final String kapsam; // Komutun kapsayıcı kategorisi
  final String kodParcasiDart; // Komutun Dart kodu stringi
  final String tanim; // Komutun kısa açıklaması

  CommandModel({
    required this.key,
    required this.kapsam,
    required this.kodParcasiDart,
    required this.tanim,
  });

  // JSON'dan CommandModel oluşturmak için factory metodu
  factory CommandModel.fromJson(String key, Map<String, dynamic> json) {
    return CommandModel(
      key: key,
      kapsam: json['kapsam'] ?? 'Genel',
      kodParcasiDart: json['kod_parçası_dart'] ?? '',
      tanim: json['tanım'] ?? 'Açıklama yok.',
    );
  }

  // CommandModel'i JSON'a dönüştürmek için metot (isteğe bağlı, gerekirse)
  Map<String, dynamic> toJson() {
    return {
      'kapsam': kapsam,
      'kod_parçası_dart': kodParcasiDart,
      'tanım': tanim,
    };
  }
}