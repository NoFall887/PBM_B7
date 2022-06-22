import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class RoomType {
  final int jumlahKasur;
  final String nama;
  final String id;
  final bool smoking;
  static Future<List<RoomType>> getData() async {
    final CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection('tipe kamar');
    try {
      return await collectionReference
          .get()
          .then((QuerySnapshot<Map<String, dynamic>> value) {
        List<RoomType> temp = value.docs.map((e) {
          Map<String, dynamic> data = e.data();
          String id = e.id;
          return RoomType(
              jumlahKasur: data["jumlah kasur"],
              nama: data["nama"],
              id: id,
              smoking: data["smoking"]);
        }).toList();
        temp.sort(((a, b) {
          if (b.smoking) {
            return 1;
          }
          return -1;
        }));
        temp.insert(
            0,
            RoomType(
                jumlahKasur: 0, nama: "Pilih kamar", id: "", smoking: false));
        return temp;
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static toList(List<RoomType> list) {}

  RoomType(
      {required this.jumlahKasur,
      required this.nama,
      required this.id,
      required this.smoking});
}
