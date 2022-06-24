import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMethodData {
  final String id;
  final String nama;

  PaymentMethodData({required this.id, required this.nama});

  static PaymentMethodData create(
      QueryDocumentSnapshot<Map<String, dynamic>> data) {
    return PaymentMethodData(id: data.id, nama: data.data()["nama"]);
  }
}
