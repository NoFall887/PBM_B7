import 'package:flutter/material.dart';
import 'package:tourly/widgets/colors.dart';

class MainBtn extends StatelessWidget {
  const MainBtn({required this.btnText, required this.onPressed, Key? key})
      : super(key: key);

  final String btnText;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
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
      onPressed: onPressed,
      child: Text(btnText),
    );
    ;
  }
}
