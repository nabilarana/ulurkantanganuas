import 'dart:convert';
import 'package:ulurkantanganuas/data/server/model/campaign.dart';

class GetDetailCampaignResponse {
  final String status;
  final String message;
  final Campaign data;

  GetDetailCampaignResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetDetailCampaignResponse.fromJson(String str) =>
      GetDetailCampaignResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetDetailCampaignResponse.fromMap(Map<String, dynamic> json) =>
      GetDetailCampaignResponse(
        status: json["status"],
        message: json["message"],
        data: Campaign.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": data.toMap(),
      };
}
