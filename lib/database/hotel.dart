class Hotel {
  String? alamat;
  String? deskripsi;
  final String nama;
  final int diskon;
  final int harga;
  final double rating;
  late int hargaAkhir;
  List<dynamic>? foto;
  List<dynamic>? fasilitas;

  static Hotel create(json) {
    return Hotel(
      nama: json['nama'],
      diskon: json['diskon'],
      harga: json['harga'],
      rating: json['rating'],
      alamat: json['alamat'],
      deskripsi: json['deskripsi'],
      fasilitas: json['fasilitas'],
      foto: json["foto"],
    );
  }

  Hotel({
    required this.nama,
    required this.diskon,
    required this.rating,
    required this.harga,
    this.alamat,
    this.deskripsi,
    this.fasilitas,
    this.foto,
  }) {
    hargaAkhir = (harga - (harga * diskon / 100)).toInt();
  }
}
