import 'package:ulurkantanganuas/data/server/model/campaign.dart';

class GetAllCampaignResponse {
  final String status;
  final String message;
  final List<Campaign> data;

  GetAllCampaignResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetAllCampaignResponse.fromJson(Map<String, dynamic> json) {
    return GetAllCampaignResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List)
                .map((item) => Campaign.fromJson(item))
                .toList()
          : [],
    );
  }
}

class GetCampaignDetailResponse {
  final String status;
  final String message;
  final Campaign? data;

  GetCampaignDetailResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory GetCampaignDetailResponse.fromJson(Map<String, dynamic> json) {
    return GetCampaignDetailResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null ? Campaign.fromJson(json['data']) : null,
    );
  }
}
