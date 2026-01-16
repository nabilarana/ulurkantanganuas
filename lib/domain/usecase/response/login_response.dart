import 'dart:convert';
import 'package:ulurkantanganuas/data/server/model/user.dart';

class LoginResponse {
  final String status;
  final String message;
  final LoginData? data;

  LoginResponse({required this.status, required this.message, this.data});

  factory LoginResponse.fromJson(String str) =>
      LoginResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] != null ? LoginData.fromMap(json["data"]) : null,
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": data?.toMap(),
  };
}

class LoginData {
  final String token;
  final User user;

  LoginData({required this.token, required this.user});

  factory LoginData.fromMap(Map<String, dynamic> json) =>
      LoginData(token: json["token"], user: User.fromMap(json["user"]));

  Map<String, dynamic> toMap() => {"token": token, "user": user.toMap()};
}
