import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class PasswordTextField extends StatefulWidget {
  final String? hint;
  final bool obscureText;
  final String? errorText;
  final Color errorColor;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final bool isEnabled;
  final bool isObscured;

  PasswordTextField({
    this.hint,
    this.obscureText = false,
    this.errorText,
    this.errorColor = AppColors.red,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.textInputAction,
    this.onFieldSubmitted,
    this.isEnabled = true,
    this.isObscured = true,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscured = true;

  @override
  void initState() {
    _isObscured = widget.isObscured;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.transparent),
      child: TextFormField(
        textAlign: TextAlign.left,
        obscureText: _isObscured,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        decoration: InputDecoration(
          isDense: true,
          fillColor: AppColors.textFieldBackgroundColor,
          filled: true,
          hintText: widget.hint,
          errorText: widget.errorText,
          enabled: widget.isEnabled,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              color: AppColors.textFieldBorderColor,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              color: AppColors.textFieldBackgroundColor,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              color: AppColors.textFieldFocusedBorderColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: AppColors.red, width: 1),
          ),
          errorStyle: TextStyle(fontSize: 14, color: widget.errorColor),
          suffixIcon: IconButton(
            icon: Icon(
              _isObscured ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isObscured = !_isObscured;
              });
            },
          ),
        ),
      ),
    );
  }
}
