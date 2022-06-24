import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class RoomType {
  final int jumlahKasur;
  final String nama;
  final String id;
  final bool smoking;
  final int harga;
  static toList(List<RoomType> list) {}

  RoomType(
      {required this.jumlahKasur,
      required this.nama,
      required this.id,
      required this.smoking,
      required this.harga});
  static RoomType create(Map<String, dynamic> data, String id) {
    return RoomType(
        jumlahKasur: data["jumlah kasur"],
        nama: data["nama"],
        id: id,
        smoking: data["smoking"],
        harga: data["harga"]);
  }
}
