import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SimpleTextField extends StatelessWidget {
  final String iconName;
  final String label;
  final String placeholder;
  final Color tintColor;
  final TextInputType textInputType;
  final FormFieldValidator validator;
  final TextEditingController controller;
  final textCapitalization;
  final Widget trailingWidget;

  SimpleTextField({
    this.iconName,
    this.label = '',
    this.placeholder = '',
    this.tintColor,
    this.textInputType = TextInputType.text,
    this.validator,
    this.controller,
    this.textCapitalization,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: placeholder,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: tintColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: tintColor),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: tintColor),
        ),
        helperText: ' ',
        prefixIcon: Padding(
          padding: EdgeInsets.all(12),
          child: SvgPicture.asset(
            iconName,
            width: 14,
            height: 14,
            color: tintColor,
          ),
        ),
      ),
      validator: validator,
    );
  }
}
