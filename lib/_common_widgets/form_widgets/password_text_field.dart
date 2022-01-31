import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';

class PasswordTextField extends StatefulWidget {
  final String label;
  final String? errorText;
  final String placeholder;
  final Color tintColor;
  final TextInputType textInputType;
  final FormFieldValidator? validator;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final textCapitalization;
  final Widget? trailingWidget;
  final isObscured;
  final FormFieldSetter<String>? onSaved;

  PasswordTextField({
    this.label = '',
    this.placeholder = '',
    this.errorText,
    this.tintColor = Colors.grey,
    this.textInputType = TextInputType.text,
    this.validator,
    this.controller,
    this.textInputAction,
    this.onFieldSubmitted,
    this.textCapitalization,
    this.trailingWidget,
    this.isObscured,
    this.onSaved,
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
      validator: widget.validator,
      obscureText: _isObscured,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      onSaved: widget.onSaved,
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
          errorText: widget.errorText,
          labelStyle: TextStyles.titleTextStyle,
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
          )),
    );
  }
}
