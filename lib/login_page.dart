import 'package:flutter/material.dart';
import 'package:tourly/colors.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          alignment: Alignment.bottomCenter,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextForm(formText: "Email", hint: "example@ex.com"),
                SizedBox(height: 30),
                TextForm(
                  formText: "Password",
                  hint: "Masukkan password",
                  isPasswordInput: true,
                ),
                SizedBox(height: 70),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(MyColor.oren),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                    fixedSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width, 45)),
                    textStyle: MaterialStateProperty.all(
                      TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                  child: Text("Masuk"),
                ),
                SizedBox(height: 150),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Belum memiliki akun?"),
                    TextButton(
                      onPressed: () {},
                      child: Text("Daftar sekarang"),
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
}

class TextForm extends StatelessWidget {
  final String formText;
  final String hint;
  final bool isPasswordInput;
  const TextForm({
    Key? key,
    required this.formText,
    required this.hint,
    this.isPasswordInput = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: formText,
        hintText: hint,
        border: UnderlineInputBorder(),
      ),
      obscureText: isPasswordInput,
      validator: (input) {
        if (input!.isEmpty) {
          return "${formText} tidak boleh kosong";
        }
        return null;
      },
    );
  }
}
