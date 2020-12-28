import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/buttons/circular_icon_button.dart';

class CircularBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  CircularBackButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CircularIconButton(
      iconName: 'assets/icons/back.svg',
      iconSize: 16,
      onPressed: onPressed,
    );
  }
}
