import 'package:ulurkantanganuas/data/server/model/user.dart';

class AuthResponse {
  final String status;
  final String message;
  final User? data;

  AuthResponse({required this.status, required this.message, this.data});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null ? User.fromJson(json['data']) : null,
    );
  }
}
