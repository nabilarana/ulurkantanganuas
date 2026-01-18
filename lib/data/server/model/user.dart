import 'dart:convert';

class User {
  final int id;
  final String nama;
  final String email;
  final String? noTelepon;
  final String? fotoProfil;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.nama,
    required this.email,
    this.noTelepon,
    this.fotoProfil,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"] ?? 0,
    nama: json["nama"] ?? "",
    email: json["email"] ?? "",
    noTelepon: json["telepon"],
    fotoProfil: json["foto_profil"],

    createdAt: json["created_at"] != null
        ? DateTime.parse(json["created_at"])
        : null,
    updatedAt: json["updated_at"] != null
        ? DateTime.parse(json["updated_at"])
        : null,
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "nama": nama,
    "email": email,
    "telepon": noTelepon,
    "foto_profil": fotoProfil,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
