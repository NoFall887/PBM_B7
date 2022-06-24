import 'package:cloud_firestore/cloud_firestore.dart';

class CreateUser {
  final String nama;
  String? username;
  String? email;
  String? id;
  CreateUser({required this.nama, this.email, this.username, this.id});

  static CreateUser fromFirestore(
      Map<String, dynamic> data, String? id, String? username) {
    return CreateUser(
        nama: data["nama"], email: data["email"], id: id, username: username);
  }

  static Stream<CreateUser>? getUserData(String? email, String? username) {
    if (email == null) {
      return null;
    }
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => fromFirestore(doc.data(), doc.id, username))
            .elementAt(0));
  }

  Map<String, dynamic> toJson() {
    return {
      "nama": this.nama,
      "email": this.email,
    };
  }
}
