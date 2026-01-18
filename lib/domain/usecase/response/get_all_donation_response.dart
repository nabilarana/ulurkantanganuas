import 'dart:convert';
import 'package:ulurkantanganuas/data/server/model/donation.dart';

class GetAllDonationResponse {
  String status;
  String message;
  DonationSummary? data;

  GetAllDonationResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory GetAllDonationResponse.fromJson(String str) =>
      GetAllDonationResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetAllDonationResponse.fromMap(Map<String, dynamic> json) =>
      GetAllDonationResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null
            ? DonationSummary.fromMap(json["data"])
            : null,
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": data?.toMap(),
  };
}

class DonationSummary {
  final int totalDonations;
  final double totalAmount;
  final List<DonationWithCampaign> donations;

  DonationSummary({
    required this.totalDonations,
    required this.totalAmount,
    required this.donations,
  });

  factory DonationSummary.fromMap(Map<String, dynamic> json) => DonationSummary(
    totalDonations: json["total_donations"] ?? 0,
    totalAmount: _parseDouble(json["total_amount"]),
    donations: json["donations"] != null
        ? List<DonationWithCampaign>.from(
            json["donations"].map((x) => DonationWithCampaign.fromMap(x)),
          )
        : [],
  );

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return (value as num).toDouble();
  }

  Map<String, dynamic> toMap() => {
    "total_donations": totalDonations,
    "total_amount": totalAmount,
    "donations": List<dynamic>.from(donations.map((x) => x.toMap())),
  };
}

class DonationWithCampaign {
  final int id;
  final double amount;
  final String donorName;
  final String? message;
  final bool isAnonymous;
  final DateTime createdAt;
  final CampaignInfo campaign;

  DonationWithCampaign({
    required this.id,
    required this.amount,
    required this.donorName,
    this.message,
    required this.isAnonymous,
    required this.createdAt,
    required this.campaign,
  });

  factory DonationWithCampaign.fromMap(Map<String, dynamic> json) {
    double parseAmount(dynamic value) {
      if (value == null) return 0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0;
      return (value as num).toDouble();
    }

    return DonationWithCampaign(
      id: json["id"],
      amount: parseAmount(json["amount"]),
      donorName: json["donor_name"] ?? 'Anonymous',
      message: json["message"],
      isAnonymous: json["is_anonymous"] ?? false,
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"])
          : DateTime.now(),
      campaign: CampaignInfo.fromMap(json["campaign"] ?? {}),
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "amount": amount,
    "donor_name": donorName,
    "message": message,
    "is_anonymous": isAnonymous,
    "created_at": createdAt.toIso8601String(),
    "campaign": campaign.toMap(),
  };
}

class CampaignInfo {
  final int id;
  final String title;
  final String? imageUrl;
  final String? category;

  CampaignInfo({
    required this.id,
    required this.title,
    this.imageUrl,
    this.category,
  });

  factory CampaignInfo.fromMap(Map<String, dynamic> json) => CampaignInfo(
    id: json["id"],
    title: json["title"],
    imageUrl: json["image_url"],
    category: json["category"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "image_url": imageUrl,
    "category": category,
  };
}
