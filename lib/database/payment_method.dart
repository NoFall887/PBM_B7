import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMethodData {
  final String id;
  final String nama;

  PaymentMethodData({required this.id, required this.nama});

  static PaymentMethodData create(Map<String, dynamic> data, String id) {
    return PaymentMethodData(id: id, nama: data["nama"]);
  }
}
