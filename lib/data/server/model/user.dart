import 'dart:convert';

class User {
  final int id;
  final String nama;
  final String email;
  final String? noTelepon;
  final String? fotoProfil;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.nama,
    required this.email,
    this.noTelepon,
    this.fotoProfil,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"],
    nama: json["nama"],
    email: json["email"],
    noTelepon: json["no_telepon"],
    fotoProfil: json["foto_profil"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "nama": nama,
    "email": email,
    "no_telepon": noTelepon,
    "foto_profil": fotoProfil,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
