import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class FormTextField extends StatelessWidget {
  final String? initialValue;
  final String? hint;
  final bool obscureText;
  final String? errorText;
  final bool isEnabled;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final int? minLines;
  final int? maxLines;
  final bool autoFocus;
  final ValueChanged<String>? onChanged;

  FormTextField({
    this.initialValue,
    this.hint,
    this.obscureText = false,
    this.errorText,
    this.isEnabled = true,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.textInputAction,
    this.onFieldSubmitted,
    this.minLines = 1,
    this.maxLines = 1,
    this.autoFocus = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.transparent),
      child: TextFormField(
        initialValue: initialValue,
        textAlign: TextAlign.left,
        obscureText: obscureText,
        keyboardType: keyboardType,
        controller: controller,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        minLines: minLines,
        maxLines: maxLines,
        autofocus: autoFocus,
        onChanged: onChanged,
        decoration: InputDecoration(
          isDense: true,
          fillColor: AppColors.textFieldBackgroundColor,
          filled: true,
          hintText: hint,
          errorText: errorText,
          enabled: isEnabled,
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
          errorStyle: TextStyle(fontSize: 14, color: AppColors.red),
        ),
      ),
    );
  }
}
