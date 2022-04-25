import 'package:flutter/material.dart';
import 'package:tourly/widgets/colors.dart';
import 'package:tourly/register_page.dart';
import 'package:email_validator/email_validator.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    EmailInput(),
                    SizedBox(height: 20),
                    PasswordInput(),
                    SizedBox(height: 20),
                    SizedBox(height: 50),
                    LoginBtn(),
                  ],
                ),
              ),
              SizedBox(height: 150),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Belum memiliki akun?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return RegisterForm();
                          },
                        ),
                      );
                    },
                    child: Text("Daftar sekarang"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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

  Widget LoginBtn() {
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
      child: Text("Masuk"),
    );
  }
}
