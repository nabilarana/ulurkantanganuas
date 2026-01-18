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
    userId: json["user_id"] ?? json["id_pengguna"] ?? 0,
    campaignId: json["campaign_id"] ?? json["id_kampanye"] ?? 0,
    amount: _parseDouble(json["amount"] ?? json["jumlah"]),
    donorName: json["donor_name"] ?? json["nama_pendonasi"] ?? 'Pendonasi',
    donorEmail: json["donor_email"],
    message: json["message"] ?? json["pesan"],
    isAnonymous: json["is_anonymous"] ?? json["anonim"] ?? false,
    createdAt: json["created_at"] != null
        ? DateTime.parse(json["created_at"])
        : json["dibuat_pada"] != null
        ? DateTime.parse(json["dibuat_pada"])
        : DateTime.now(),
  );

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return (value as num).toDouble();
  }

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
