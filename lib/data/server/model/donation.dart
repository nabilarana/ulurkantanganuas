import 'dart:convert';

class Donation {
  int id;
  int userId;
  int campaignId;
  double amount;
  String donorName;
  String? donorEmail;
  String? message;
  bool isAnonymous;
  DateTime createdAt;

  Donation({
    required this.id,
    required this.userId,
    required this.campaignId,
    required this.amount,
    required this.donorName,
    this.donorEmail,
    this.message,
    required this.isAnonymous,
    required this.createdAt,
  });

  factory Donation.fromJson(String str) => Donation.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Donation.fromMap(Map<String, dynamic> json) => Donation(
    id: json["id"],
    userId: json["user_id"],
    campaignId: json["campaign_id"],
    amount: (json["amount"] as num).toDouble(),
    donorName: json["donor_name"],
    donorEmail: json["donor_email"],
    message: json["message"],
    isAnonymous: json["is_anonymous"] ?? false,
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "user_id": userId,
    "campaign_id": campaignId,
    "amount": amount,
    "donor_name": donorName,
    "donor_email": donorEmail,
    "message": message,
    "is_anonymous": isAnonymous,
    "created_at": createdAt.toIso8601String(),
  };
}
