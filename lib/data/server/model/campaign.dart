import 'dart:convert';

class Campaign {
  final int id;
  final String judul;
  final String deskripsi;
  final double targetDana;
  final double danaTerkumpul;
  final String? fotoUtama;
  final String? categoryName;
  final DateTime createdAt;

  Campaign({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.targetDana,
    required this.danaTerkumpul,
    this.fotoUtama,
    this.categoryName,
    required this.createdAt,
  });

  factory Campaign.fromJson(String str) => Campaign.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Campaign.fromMap(Map<String, dynamic> json) => Campaign(
    id: json["id"],
    judul: json["judul"],
    deskripsi: json["deskripsi"],
    fotoUtama: json["foto_utama"],
    targetDana: (json["target_dana"] as num).toDouble(),
    danaTerkumpul: (json["dana_terkumpul"] as num).toDouble(),
    categoryName: json["category_name"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "judul": judul,
    "deskripsi": deskripsi,
    "foto_utama": fotoUtama,
    "target_dana": targetDana,
    "dana_terkumpul": danaTerkumpul,
    "category_name": categoryName,
    "created_at": createdAt.toIso8601String(),
  };

  double get progressPercentage {
    if (targetDana == 0) return 0;
    return (danaTerkumpul / targetDana * 100).clamp(0, 100);
  }
}
