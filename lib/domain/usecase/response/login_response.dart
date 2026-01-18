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
  final String? token;
  final User? user;

  LoginData({this.token, this.user});

  factory LoginData.fromMap(Map<String, dynamic> json) {
    return LoginData(
      token: json["token"], // This can now safely return null

      user: json["user"] != null
          ? User.fromMap(json["user"])
          : (json["id"] != null ? User.fromMap(json) : null),
    );
  }

  Map<String, dynamic> toMap() => {
    "token": token,
    "user": user?.toMap(), // Handle nullable user
  };
}
