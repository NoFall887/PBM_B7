import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:tourly/login_page.dart';

import 'widgets/colors.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _passConfirmController = TextEditingController();

  String email = "";
  String password = "";
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
      validator: (input) {
        if (input!.isEmpty) {
          return "Email tidak boleh kosong";
        } else if (!EmailValidator.validate(input, true)) {
          return "Email tidak valid";
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          email = value!;
        });
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
      validator: (input) {
        if (input!.isEmpty) {
          return "password tidak boleh kosong";
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          password = value!;
        });
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
      validator: (input) {
        if (input!.isEmpty) {
          return "password tidak cocok";
        } else if (input != _passController.text) {
          return "password tidak cocok";
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          password = value!;
        });
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
      onPressed: () {
        final isValid = _formKey.currentState!.validate();
        if (isValid) {
          _formKey.currentState?.save();
        }
      },
      child: Text("Daftar"),
    );
  }
}
