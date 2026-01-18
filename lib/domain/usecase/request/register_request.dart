class RegisterRequest {
  final String nama;
  final String email;
  final String password;
  final String confirmPasswor;
  final String? noTelepon;

  RegisterRequest({
    required this.nama,
    required this.email,
    required this.password,
    required this.confirmPasswor,
    this.noTelepon,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nama': nama,
      'email': email,
      'password': password,
      'confirm_password': confirmPasswor,
      'telepon': noTelepon ?? '',
    };
  }
}
