// ignore_for_file: use_super_parameters, prefer_const_constructors

import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData? prefixIcon;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.prefixIcon,
  }) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText && _obscureText,
        decoration: InputDecoration(
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon, color: Colors.blue,) : null,
        enabledBorder: OutlineInputBorder( borderSide: BorderSide(color: Colors.white),
          ),
        focusedBorder: OutlineInputBorder( borderSide: BorderSide(color: Colors.blue),
          ),
          filled: true,
          fillColor: Colors.blue.withOpacity(0.1),
          hintText: widget.hintText,
          suffixIcon: widget.obscureText
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  icon: Icon(
                      _obscureText ? Icons.visibility  : Icons.visibility_off),
                      color: Colors.blue,
                )
              : null,
        ),
      ),
    );
  }
}
