import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tourly/history_page.dart';
import 'package:tourly/home_page.dart';
import 'package:tourly/hotel_detail_page.dart';
import 'package:tourly/hotel_nearby.dart';
import 'package:tourly/login_page.dart';
import 'package:tourly/profile_page.dart';
import 'package:tourly/search.dart';
import 'package:tourly/transaction_succes.dart';
import 'package:tourly/ulasan.dart';
import 'package:tourly/wishlist.dart';
import 'package:tourly/bottom_navigation_bar.dart';
// import 'package:tourly/camera_page.dart';
import 'package:tourly/upload_file.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      title: "Tourly",
      home: Transaction_Suc(),
    );
  }
}
