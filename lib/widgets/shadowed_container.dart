import 'dart:ffi';

import 'package:flutter/material.dart';

class ShadowedContainer extends StatelessWidget {
  final Widget child;
  bool usePadding;
  ShadowedContainer({Key? key, required this.child, this.usePadding = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      child: child,
      width: double.infinity,
      padding: usePadding
          ? const EdgeInsets.symmetric(vertical: 14, horizontal: 10)
          : null,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            offset: const Offset(0, 4),
            blurRadius: 6,
            spreadRadius: 3,
          ),
        ],
      ),
    );
  }
}
