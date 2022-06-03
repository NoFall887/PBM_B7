import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourly/history_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          children: [
            ProfileBox(),
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
            // WhiteLongButton(
            //     displayText: "Logout",
            //     onPressed: () {
            //       FirebaseAuth.instance.signOut();
            //     })
          ],
        ),
      ),
    );
  }

  Widget ProfileBox() {
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
            "Nama user",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
