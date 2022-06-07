import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourly/database/user.dart';
import 'package:tourly/history_page.dart';

class ProfilePage extends StatelessWidget {
  final String userEmail;

  const ProfilePage({Key? key, required this.userEmail}) : super(key: key);

  // Stream
  Future<CreateUser?> readUser() async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');

    final query = collectionReference.where("email", isEqualTo: userEmail);
    final snapshot = await query.get();

    return CreateUser.fromJson(snapshot.docs.single);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Akun Saya"),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: FutureBuilder<CreateUser?>(
          future: readUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final String username = snapshot.data!.nama;
              return buildPage(username);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget buildPage(String username) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          ProfileBox(username),
          SizedBox(height: 50),
          WhiteLongButton(
            displayText: "Refund saya",
            onPressed: () {},
          ),
          SizedBox(height: 10),
          WhiteLongButton(
            displayText: "Pusat Bantuan",
            onPressed: () {},
          ),
          SizedBox(height: 10),
          WhiteLongButton(
            displayText: "Pengaturan",
            onPressed: () {},
          ),
          WhiteLongButton(
              displayText: "Logout",
              onPressed: () {
                FirebaseAuth.instance.signOut();
              })
        ],
      ),
    );
  }

  Widget ProfileBox(String username) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 33,
            backgroundImage: NetworkImage(
                "https://cdn.pixabay.com/photo/2016/03/31/19/56/avatar-1295394__340.png"),
          ),
          SizedBox(width: 23),
          Text(
            username,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
