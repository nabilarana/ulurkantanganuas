class User {
  final int id;
  final String nama;
  final String email;
  final String? telepon;
  final String? fotoProfil;

  User({
    required this.id,
    required this.nama,
    required this.email,
    this.telepon,
    this.fotoProfil,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      telepon: json['telepon'],
      fotoProfil: json['foto_profil'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'telepon': telepon,
      'foto_profil': fotoProfil,
    };
  }
}
