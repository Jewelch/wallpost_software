import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';

class RoundedBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  RoundedBackButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RoundedIconButton(
      iconName: 'assets/icons/back.svg',
      iconSize: 16,
      onPressed: onPressed,
    );
  }
}
