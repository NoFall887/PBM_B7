import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourly/database/facility.dart';
import 'package:tourly/database/hotel.dart';
import 'package:tourly/database/payment_method.dart';
import 'package:tourly/database/room_type.dart';
import 'package:tourly/database/user.dart';

class Order {
  String? id;
  final DateTime checkIn;
  final DateTime checkOut;
  DateTime orderDate;
  final int jumlah;
  final String email;
  final Hotel hotel;
  final RoomType roomType;
  final String namaPenghuni;
  DateTime? limit;
  PaymentMethodData? paymentMethodData;
  final bool isDone;
  final CreateUser user;
  String? reviewId;

  Order({
    required this.checkIn,
    required this.checkOut,
    required this.orderDate,
    required this.jumlah,
    required this.email,
    required this.hotel,
    required this.roomType,
    required this.namaPenghuni,
    this.reviewId,
    this.paymentMethodData,
    this.isDone = false,
    required this.user,
    this.limit,
    this.id,
  });
  static Future<Order> createFromFirestore(
      Map<String, dynamic> orderData, CreateUser user, String id) async {
    // fetch hotel data
    DocumentReference<Map<String, dynamic>> hotelReference = orderData["hotel"];
    Map<String, dynamic>? hotelData =
        await hotelReference.snapshots().first.then(
              (value) => value.data(),
            );
    Hotel hotel =
        Hotel.create(Facility.castFacilities(hotelData!), hotelReference.id);

    // Fetch room data
    DocumentReference<Map<String, dynamic>> roomReference =
        orderData["tipe kamar"];
    Map<String, dynamic>? roomData = await roomReference.snapshots().first.then(
          (value) => value.data(),
        );
    RoomType roomType = RoomType.create(roomData!, roomReference.id);

    // fetch payment method
    DocumentReference<Map<String, dynamic>> paymentReference =
        orderData["bank"];
    Map<String, dynamic>? paymentData =
        await paymentReference.snapshots().first.then(
              (value) => value.data(),
            );
    PaymentMethodData paymentMethodData =
        PaymentMethodData.create(paymentData!, paymentReference.id);

    return Order(
      checkIn: orderData["checkin"].toDate(),
      checkOut: orderData["checkout"].toDate(),
      orderDate: orderData["tanggal pesanan"].toDate(),
      jumlah: orderData["jumlah"],
      email: orderData["email"],
      hotel: hotel,
      roomType: roomType,
      namaPenghuni: orderData["nama penghuni"],
      limit: orderData["batas"].toDate(),
      isDone: orderData["selesai"],
      user: user,
      paymentMethodData: paymentMethodData,
      id: id,
    );
  }

  Map<String, dynamic> toMap() {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DocumentReference hotelReference =
        firebaseFirestore.collection("hotel").doc(hotel.id);
    DocumentReference roomReference =
        firebaseFirestore.collection("tipe kamar").doc(roomType.id);
    DocumentReference paymentMethodReference =
        firebaseFirestore.collection("bank").doc(paymentMethodData!.id);
    DocumentReference userReference =
        firebaseFirestore.collection("user").doc(user.id);
    return {
      "checkin": checkIn,
      "checkout": checkOut,
      "tanggal pesanan": orderDate,
      "jumlah": jumlah,
      "email": email,
      "hotel": hotelReference,
      "tipe kamar": roomReference,
      "nama penghuni": namaPenghuni,
      "bank": paymentMethodReference,
      "selesai": isDone,
      "user": userReference,
      "batas": limit
    };
  }
}
