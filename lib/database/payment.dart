import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourly/database/order.dart';
import 'package:tourly/database/payment_method.dart';
import 'package:tourly/database/user.dart';

class Payment {
  String? id;
  final String orderId;
  final PaymentMethodData paymentMethodData;
  final DateTime dateLimit;
  final bool isDone;
  final CreateUser user;

  Payment({
    required this.paymentMethodData,
    required this.orderId,
    this.isDone = false,
    this.id,
    required this.user,
    required this.dateLimit,
  });

  Map<String, dynamic> toMap() {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DocumentReference bankReference =
        firebaseFirestore.collection("bank").doc(paymentMethodData.id);
    DocumentReference orderReference =
        firebaseFirestore.collection("pesanan").doc(orderId);
    DocumentReference userReference =
        firebaseFirestore.collection("user").doc(user.id);
    return {
      "bank": bankReference,
      "batas": dateLimit,
      "pesanan": orderReference,
      "selesai": isDone,
      "user": userReference,
    };
  }
}
