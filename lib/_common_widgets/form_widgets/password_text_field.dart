import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class PasswordTextField extends StatefulWidget {
  // final String iconName;
  final String label;
  final String placeholder;
  final Color tintColor;
  final TextInputType textInputType;
  final FormFieldValidator validator;
  final TextEditingController controller;
  final textCapitalization;
  final Widget trailingWidget;
  final isObscured;

  PasswordTextField({
    //this.iconName,
    this.label = '',
    this.placeholder = '',
    this.tintColor = Colors.grey,
    this.textInputType = TextInputType.text,
    this.validator,
    this.controller,
    this.textCapitalization,
    this.trailingWidget,
    this.isObscured,
  });

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscured = true;

  @override
  void initState() {
    _isObscured = widget.isObscured != null ? widget.isObscured : true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscured,
      autofocus: true,
      decoration: InputDecoration(
          hintText: widget.placeholder,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: widget.tintColor),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: widget.tintColor),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: widget.tintColor),
          ),
          labelText: widget.label,
          labelStyle:
          TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          helperText: ' ',
          suffixIcon: IconButton(
            icon: Icon(
              _isObscured ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isObscured = !_isObscured;
              });
            },
          )),
      validator: widget.validator,
    );
  }
}
