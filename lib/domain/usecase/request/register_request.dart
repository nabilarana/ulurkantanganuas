class RegisterRequest {
  final String nama;
  final String email;
  final String password;
  final String? telepon;

  RegisterRequest({
    required this.nama,
    required this.email,
    required this.password,
    this.telepon,
  });

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'email': email,
      'password': password,
      'telepon': telepon,
    };
  }
}
