import 'package:ulurkantanganuas/data/server/model/donasi.dart';

class DonationResponse {
  final String status;
  final String message;
  final Donasi? data;

  DonationResponse({required this.status, required this.message, this.data});

  factory DonationResponse.fromJson(Map<String, dynamic> json) {
    return DonationResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null ? Donasi.fromJson(json['data']) : null,
    );
  }
}
