// @dart=2.9

import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';

class MultiLineTextField extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextInputType textInputType;
  final FormFieldValidator validator;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final ValueChanged<String> onFieldSubmitted;
  final textCapitalization;
  final Widget trailingWidget;
  final FormFieldSetter<String> onSaved;

  MultiLineTextField({
    this.label = '',
    this.placeholder = '',
    this.textInputType = TextInputType.text,
    this.validator,
    this.controller,
    this.textInputAction,
    this.onFieldSubmitted,
    this.textCapitalization,
    this.trailingWidget,
    this.onSaved,
  });
  @override
  _MultiLineTextFieldState createState() => _MultiLineTextFieldState();
}

class _MultiLineTextFieldState extends State<MultiLineTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      minLines: null,
      maxLines: null,
      enableInteractiveSelection: false,
      controller: widget.controller,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      onSaved: widget.onSaved,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 6),
        isDense: true,
        hintText: widget.placeholder,
        hintStyle: TextStyles.subTitleTextStyle,
        hintMaxLines: 2,
        labelText: widget.label,
        labelStyle:
            TextStyles.largeTitleTextStyle.copyWith(color: Colors.black),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
