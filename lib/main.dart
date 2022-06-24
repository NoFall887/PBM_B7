import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:tourly/database/user.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:tourly/login_page.dart';
import 'package:tourly/bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tourly/payment_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
            value: FirebaseAuth.instance.authStateChanges(), initialData: null),
      ],
      child: AppWrapper(),
    );
  }
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<User?>(context);
    // if (user == null) {
    //   return Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }
    final String? username = user?.displayName;
    final String? email = user?.email;

    return StreamProvider.value(
      value: CreateUser.getUserData(email, username),
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'Poppins', primaryColor: Colors.blue.shade300),
        title: "Tourly",
        home: (user?.email == null ? LoginForm() : Navbar()),
      ),
    );
  }
}
