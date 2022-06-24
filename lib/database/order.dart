import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourly/database/hotel.dart';
import 'package:tourly/database/room_type.dart';

class Order {
  final DateTime checkIn;
  final DateTime checkOut;
  DateTime orderDate;
  final int jumlah;
  final String email;
  final Hotel hotel;
  final RoomType roomType;
  final String namaPenghuni;
  String? reviewId;

  Order(
      {required this.checkIn,
      required this.checkOut,
      required this.orderDate,
      required this.jumlah,
      required this.email,
      required this.hotel,
      required this.roomType,
      required this.namaPenghuni,
      this.reviewId});
  // static Order create(){

  // }
  Map<String, dynamic> toMap() {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DocumentReference hotelReference =
        firebaseFirestore.collection("hotel").doc(hotel.id);
    DocumentReference roomReference =
        firebaseFirestore.collection("tipe kamar").doc(roomType.id);

    return {
      "checkin": checkIn,
      "checkout": checkOut,
      "tanggal pesanan": orderDate,
      "jumlah": jumlah,
      "email": email,
      "hotel": hotelReference,
      "tipe kamar": roomReference,
      "nama penghuni": namaPenghuni,
    };
  }
}
