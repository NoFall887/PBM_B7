import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourly/database/hotel.dart';
import 'package:tourly/database/user.dart';

class UlasanData {
  String? id;
  final String foto;
  Hotel? hotel;
  final String ulasan;
  CreateUser? user;
  final double rating;
  UlasanData({
    this.id,
    required this.foto,
    this.hotel,
    required this.ulasan,
    this.user,
    required this.rating,
  });
  static UlasanData create(Map<String, dynamic> json, String id) {
    print(json);
    return UlasanData(
      foto: json["foto"],
      ulasan: json["ulasan"],
      rating: json["rating"],
    );
  }

  Map<String, dynamic> toMap() {
    DocumentReference hotelReference =
        FirebaseFirestore.instance.collection("hotel").doc(hotel!.id);
    DocumentReference userReference =
        FirebaseFirestore.instance.collection("user").doc(user!.id);
    return {
      "foto": foto,
      "hotel": hotelReference,
      "rating": rating,
      "ulasan": ulasan,
      "user": userReference,
    };
  }
}
