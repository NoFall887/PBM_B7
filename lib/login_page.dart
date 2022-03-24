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
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Form(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextForm(formText: "Email", hint: "example@ex.com"),
                  SizedBox(height: 20),
                  TextForm(
                    formText: "Password",
                    hint: "Masukkan password",
                    isPasswordInput: true,
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(MyColor.oren),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      fixedSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width, 40)),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 5),
                      ),
                      textStyle: MaterialStateProperty.all(
                        TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {}
                    },
                    child: Text("Masuk"),
                  )
                ],
              ),
            )),
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
