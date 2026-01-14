class Donasi {
  final int id;
  final int idPengguna;
  final int idKampanye;
  final double jumlah;
  final String? pesan;
  final bool anonim;
  final String status;
  final String dibuatPada;

  Donasi({
    required this.id,
    required this.idPengguna,
    required this.idKampanye,
    required this.jumlah,
    this.pesan,
    required this.anonim,
    required this.status,
    required this.dibuatPada,
  });

  factory Donasi.fromJson(Map<String, dynamic> json) {
    return Donasi(
      id: json['id'] ?? 0,
      idPengguna: json['id_pengguna'] ?? 0,
      idKampanye: json['id_kampanye'] ?? 0,
      jumlah: double.parse(json['jumlah'].toString()),
      pesan: json['pesan'],
      anonim: json['anonim'] == 1 || json['anonim'] == true,
      status: json['status'] ?? 'selesai',
      dibuatPada: json['dibuat_pada'] ?? '',
    );
  }
}
