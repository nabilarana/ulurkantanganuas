import 'dart:convert';
import 'package:ulurkantanganuas/data/server/model/donation.dart';

class DonationResponse {
  final String status;
  final String message;
  final Donation? data;

  DonationResponse({required this.status, required this.message, this.data});

  factory DonationResponse.fromJson(String str) =>
      DonationResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DonationResponse.fromMap(Map<String, dynamic> json) =>
      DonationResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null ? Donation.fromMap(json["data"]) : null,
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": data?.toMap(),
  };
}
