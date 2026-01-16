class RegisterRequest {
  final String nama;
  final String email;
  final String password;
  final String? noTelepon;

  RegisterRequest({
    required this.nama,
    required this.email,
    required this.password,
    this.noTelepon,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nama': nama,
      'email': email,
      'password': password,
      'no_telepon': noTelepon ?? '',
    };
  }
}
