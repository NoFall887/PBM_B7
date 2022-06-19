import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourly/history_page.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pengaturan"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            WhiteLongButton(displayText: "Informasi akun", onPressed: () {}),
            SizedBox(
              height: 30,
            ),
            WhiteLongButton(displayText: "Versi", onPressed: () {}),
            SizedBox(
              height: 30,
            ),
            WhiteLongButton(displayText: "Tentang kami", onPressed: () {}),
            SizedBox(
              height: 30,
            ),
            WhiteLongButton(
                displayText: "Logout",
                onPressed: () {
                  FirebaseAuth.instance
                      .signOut()
                      .then((value) => Navigator.pop(context));
                }),
            SizedBox(
              height: 30,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      ),
    );
  }
}
