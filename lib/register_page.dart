import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourly/bottom_navigation_bar.dart';
import 'package:tourly/login_page.dart';

import 'widgets/colors.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _passConfirmController = TextEditingController();

  Future signUp() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState?.save();

      showDialog(
        context: context,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passController.text);
      } catch (e) {
        print(e);
      }

      Navigator.popUntil(context, ((route) => route.isFirst));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrasi"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height -
                (MediaQuery.of(context).padding.top + kToolbarHeight),
            alignment: Alignment.center,
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      UsernameInput(),
                      SizedBox(height: 20),
                      EmailInput(),
                      SizedBox(height: 20),
                      PasswordInput(),
                      SizedBox(height: 20),
                      PasswordConfirmInput(),
                      SizedBox(height: 70),
                      RegisterBtn()
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Sudah memiliki akun?"),
                    TextButton(
                      child: Text("Login Sekarang"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget UsernameInput() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Username",
        border: UnderlineInputBorder(),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (input) {
        if (input!.isEmpty) {
          return "Username tidak boleh kosong";
        }
        return null;
      },
    );
  }

  Widget EmailInput() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Email",
        border: UnderlineInputBorder(),
      ),
      controller: _emailController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.emailAddress,
      validator: (input) {
        if (input!.isEmpty) {
          return "Email tidak boleh kosong";
        } else if (!EmailValidator.validate(input)) {
          return "Email tidak valid";
        }
        return null;
      },
    );
  }

  Widget PasswordInput() {
    return TextFormField(
      controller: _passController,
      decoration: InputDecoration(
        labelText: "Password",
        border: UnderlineInputBorder(),
      ),
      obscureText: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (input) {
        if (input!.isEmpty) {
          return "password tidak boleh kosong";
        } else if (input.length < 6) {
          return "minimal 6 karakter";
        }
        return null;
      },
    );
  }

  Widget PasswordConfirmInput() {
    return TextFormField(
      controller: _passConfirmController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: "Konfirmasi password",
        border: UnderlineInputBorder(),
      ),
      obscureText: true,
      validator: (input) {
        if (input!.isEmpty || input != _passController.text) {
          return "password tidak cocok";
        }
        return null;
      },
    );
  }

  Widget RegisterBtn() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(MyColor.oren),
        foregroundColor: MaterialStateProperty.all(Colors.black),
        fixedSize: MaterialStateProperty.all(
            Size(MediaQuery.of(context).size.width, 50)),
        textStyle: MaterialStateProperty.all(
          TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      onPressed: signUp,
      child: Text("Daftar"),
    );
  }
}
