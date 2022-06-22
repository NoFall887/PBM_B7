import 'package:cloud_firestore/cloud_firestore.dart';

class Hotel {
  String? alamat;
  String? deskripsi;
  final String nama;
  final int diskon;
  final int harga;
  final double rating;
  late int hargaAkhir;
  final List<dynamic> foto;
  final List<DocumentReference<Map<String, dynamic>>> fasilitas;

  final double? jarak;
  final GeoPoint? koordinat;
  static Hotel create(json) {
    return Hotel(
      nama: json['nama'],
      diskon: json['diskon'],
      harga: json['harga'],
      rating: json['rating'].toDouble(),
      alamat: json['alamat'],
      deskripsi: json['deskripsi'],
      fasilitas: json['fasilitas'],
      foto: json["foto"],
    );
  }

  static Hotel createNearby(json, double distance) {
    return Hotel(
        nama: json['nama'],
        diskon: json['diskon'],
        harga: json['harga'],
        rating: json['rating'].toDouble(),
        alamat: json['alamat'],
        deskripsi: json['deskripsi'],
        fasilitas: json['fasilitas'],
        foto: json["foto"],
        jarak: distance,
        koordinat: json["koordinat"]["geopoint"]);
  }

  Hotel(
      {required this.nama,
      required this.diskon,
      required this.rating,
      required this.harga,
      required this.alamat,
      required this.deskripsi,
      required this.fasilitas,
      required this.foto,
      this.jarak,
      this.koordinat}) {
    hargaAkhir = (harga - (harga * diskon / 100)).toInt();
  }
}
