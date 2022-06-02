import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:tourly/login_page.dart';

import 'package:tourly/bottom_navigation_bar.dart';

import 'package:firebase_auth/firebase_auth.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(fontFamily: 'Poppins', primaryColor: Colors.blue.shade300),
      title: "Tourly",
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          } else if (snapshot.hasData) {
            return Navbar();
          } else {
            return LoginForm();
          }
        },
      ),
    );
  }
}
