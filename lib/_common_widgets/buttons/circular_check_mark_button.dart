import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/buttons/circular_icon_button.dart';

class CircularCheckMarkButton extends CircularIconButton {
  final Color iconColor;
  final Color color;
  final VoidCallback onPressed;

  CircularCheckMarkButton({this.iconColor, this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CircularIconButton(
      iconName: 'assets/icons/check.svg',
      iconSize: 18,
      iconColor: iconColor,
      color: color,
      onPressed: onPressed,
    );
  }
}
