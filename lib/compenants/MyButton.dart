
// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String TextButton;

  // ignore: prefer_typing_uninitialized_variables
  final ButtonColor;
  final VoidCallback onPressed;
  const MyButton({super.key , required this.TextButton , required this.ButtonColor, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: GestureDetector(
        onTap:onPressed ,
        child: Container(
           decoration: BoxDecoration(color: ButtonColor , borderRadius: BorderRadius.circular(10)),
            height: 70,
            child: Center(
                child: Text(
              TextButton,
              style: TextStyle(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ))),
      ),
    );

  }
}