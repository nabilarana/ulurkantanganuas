class DonationRequest {
  final int userId;
  final int campaignId;
  final double amount;
  final String donorName;
  final String? donorEmail;
  final String? message;
  final bool isAnonymous;

  DonationRequest({
    required this.userId,
    required this.campaignId,
    required this.amount,
    required this.donorName,
    this.donorEmail,
    this.message,
    required this.isAnonymous,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id_pengguna': userId,
      'id_kampanye': campaignId,
      'jumlah': amount,
      'pesan': message ?? '',
      'anonim': isAnonymous,
    };
  }
}
