import 'dart:io';

class DonationRequest {
  final int campaignId;
  final double amount;
  final String donorName;
  final String? donorEmail;
  final String? message;
  final bool isAnonymous;

  DonationRequest({
    required this.campaignId,
    required this.amount,
    required this.donorName,
    this.donorEmail,
    this.message,
    required this.isAnonymous,
  });

  Map<String, String> toMap() {
    return <String, String>{
      'campaign_id': campaignId.toString(),
      'amount': amount.toString(),
      'donor_name': donorName,
      'donor_email': donorEmail ?? '',
      'message': message ?? '',
      'is_anonymous': isAnonymous ? '1' : '0',
    };
  }
}