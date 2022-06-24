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
}
