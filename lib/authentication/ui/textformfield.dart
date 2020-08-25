import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;

  CustomTextField({this.hint});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      textAlign: TextAlign.center,
      cursorColor: Colors.blue[200],
      decoration: InputDecoration(
        hintText: hint,
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide.none),
      ),
    );
  }
}
