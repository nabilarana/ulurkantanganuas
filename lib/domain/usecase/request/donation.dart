class DonationRequest {
  final int idUser;
  final int idKampanye;
  final double jumlah;
  final String? pesan;
  final bool anonim;

  DonationRequest({
    required this.idUser,
    required this.idKampanye,
    required this.jumlah,
    this.pesan,
    this.anonim = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'id_kampanye': idKampanye,
      'jumlah': jumlah,
      'pesan': pesan,
      'anonim': anonim ? 1 : 0,
    };
  }
}
