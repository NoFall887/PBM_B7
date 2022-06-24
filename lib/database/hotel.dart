import 'package:cloud_firestore/cloud_firestore.dart';

class Hotel {
  String? alamat;
  String? deskripsi;
  final String id;
  final String nama;
  final int diskon;
  final int harga;
  final double rating;
  late int hargaAkhir;
  final List<dynamic> foto;
  final List<DocumentReference<Map<String, dynamic>>> fasilitas;

  final double? jarak;
  final GeoPoint? koordinat;
  static Hotel create(json, String id) {
    return Hotel(
      nama: json['nama'],
      diskon: json['diskon'],
      harga: json['harga'],
      rating: json['rating'].toDouble(),
      alamat: json['alamat'],
      deskripsi: json['deskripsi'],
      fasilitas: json['fasilitas'],
      foto: json["foto"],
      id: id,
    );
  }

  static Hotel createNearby(json, double distance, String id) {
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
        koordinat: json["koordinat"]["geopoint"],
        id: id);
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
      required this.id,
      this.jarak,
      this.koordinat}) {
    hargaAkhir = (harga - (harga * diskon / 100)).toInt();
  }
}
