import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourly/bottom_navigation_bar.dart';
import 'package:tourly/main.dart';
import 'package:tourly/widgets/colors.dart';
import 'package:tourly/register_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:tourly/widgets/main_btn.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future signIn() async {
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
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
      } catch (e) {
        print(e);
        
      }
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
          centerTitle: true,
        ),
        body: LoginForm());
  }

  Widget LoginForm() {
    return Container(
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
                  MainBtn(
                    btnText: "Login",
                    onPressed: signIn,
                  ),
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
                          settings: RouteSettings(name: 'login'),
                          builder: (context) => RegisterForm(),
                        ));
                  },
                  child: Text("Daftar sekarang"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget EmailInput() {
    return TextFormField(
      controller: _emailController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: "Email",
        border: UnderlineInputBorder(),
      ),
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
      controller: _passwordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: "Password",
        border: UnderlineInputBorder(),
      ),
      validator: (input) {
        if (input!.isEmpty) {
          return "password tidak boleh kosong";
        } else if (input.length < 6) {
          return "minimal 6 karakter";
        }
        return null;
      },
      obscureText: true,
    );
  }
}
