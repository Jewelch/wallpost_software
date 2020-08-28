import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextInputType inputType;

  CustomTextField({this.hint, this.inputType});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType,
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
         //   borderSide:new BorderSide(color: Colors.teal,width: 15.0)
         ),
      ),
      validator: validateAccount,
    );
  }

   String validateAccount(value) {
    if (value.isEmpty) {
      return 'Please enter valied Account number';
    } else {
      return null ;
    }
  }
}
