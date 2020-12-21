import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class RoundedIconButton extends StatelessWidget {
  final String iconName;
  final double iconSize;
  final Color iconColor;
  final double buttonSize;
  final Color color;
  final VoidCallback onPressed;

  RoundedIconButton(
      {this.iconName,
      this.iconSize = 20,
      this.iconColor = Colors.white,
      this.buttonSize = 44,
      this.color,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonSize,
      height: buttonSize,
      child: FlatButton(
        color: color ?? AppColors.defaultColor,
        padding: EdgeInsets.all(0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
        child: SvgPicture.asset(
          iconName,
          width: iconSize,
          height: iconSize,
          color: iconColor,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
