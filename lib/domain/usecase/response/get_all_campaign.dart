import 'dart:convert';
import 'package:ulurkantanganuas/data/server/model/campaign.dart';

class GetAllCampaignResponse {
  String status;
  String message;
  List<Campaign> data;

  GetAllCampaignResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetAllCampaignResponse.fromJson(String str) =>
      GetAllCampaignResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetAllCampaignResponse.fromMap(Map<String, dynamic> json) =>
      GetAllCampaignResponse(
        status: json["status"],
        message: json["message"],
        data: List<Campaign>.from(
          json["data"].map((x) => Campaign.fromMap(x)),
        ),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}
