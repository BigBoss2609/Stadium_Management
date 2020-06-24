import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SahaTextField extends StatelessWidget {
  String labelText;
  Icon icon;
  TextEditingController controller;
  Function(String) onChanged;
  bool obscureText;
  TextInputType textInputType;
  SahaTextField({
    this.labelText,
    this.controller,
    this.icon,
    this.onChanged,
    this.obscureText = false,
    this.textInputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextField(
      keyboardType: textInputType,
      obscureText: obscureText,
      onChanged: onChanged,
      controller: controller,
      decoration: new InputDecoration(
          border: new OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide: new BorderSide(color: Colors.white)),
          labelText: labelText,
          prefixIcon: icon,
          prefixText: ' ',
          suffixStyle: const TextStyle(color: Colors.green)),
    );
  }
}
