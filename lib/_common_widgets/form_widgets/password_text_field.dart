import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallpost/_shared/constants/app_images.dart';

class PasswordTextField extends StatefulWidget {
  final String iconName;
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
    this.iconName,
    this.label = '',
    this.placeholder = '',
    this.tintColor,
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
        helperText: ' ',
        prefixIcon: Padding(
          padding: EdgeInsets.all(12),
          child: SvgPicture.asset(
            widget.iconName,
            width: 14,
            height: 14,
            color: widget.tintColor,
          ),
        ),
        suffixIcon: IconButton(
          padding: EdgeInsets.all(0),
          iconSize: 20,
          icon: SvgPicture.asset(
            _isObscured ? AppImages.eyeEmptyIcon : AppImages.eyeFilledIcon,
            width: 24,
            height: 24,
          ),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
        ),
      ),
      validator: widget.validator,
    );
  }
}
