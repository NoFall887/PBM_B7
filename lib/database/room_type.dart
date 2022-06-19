import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class RoomType {
  final int jumlahKasur;
  final String nama;
  final String id;
  static Future<List<RoomType>> getData() async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('tipe kamar');
    try {
      return await collectionReference.get().then((value) {
        List<RoomType> temp = value.docs
            .map((e) => RoomType(
                jumlahKasur: e["jumlah kasur"], nama: e["nama"], id: e.id))
            .toList();
        temp.insert(0, RoomType(jumlahKasur: 0, nama: "Pilih kamar", id: ""));
        return temp;
      });
    } catch (e) {
      rethrow;
    }
  }

  static toList(List<RoomType> list) {}

  RoomType({required this.jumlahKasur, required this.nama, required this.id});
}
