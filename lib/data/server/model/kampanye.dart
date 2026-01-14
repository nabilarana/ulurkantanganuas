class Campaign {
  final int id;
  final String judul;
  final String deskripsi;
  final String kategori;
  final double targetDana;
  final double danaTerkumpul;
  final String? urlGambar;
  final String status;

  Campaign({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.kategori,
    required this.targetDana,
    required this.danaTerkumpul,
    this.urlGambar,
    required this.status,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'] ?? 0,
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      kategori: json['kategori'] ?? '',
      targetDana: double.parse(json['target_dana'].toString()),
      danaTerkumpul: double.parse(json['dana_terkumpul'].toString()),
      urlGambar: json['url_gambar'],
      status: json['status'] ?? 'aktif',
    );
  }

  double get persentase {
    if (targetDana == 0) return 0;
    return (danaTerkumpul / targetDana) * 100;
  }
}
