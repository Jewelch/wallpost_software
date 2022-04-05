import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class CircularIconButton extends StatelessWidget {
  final String iconName;
  final double iconSize;
  final Color? iconColor;
  final double buttonHeight;
  final double buttonWidth;
  final Color? color;
  final VoidCallback? onPressed;

  CircularIconButton({
    required this.iconName,
    this.iconSize = 20,
    this.iconColor = Colors.white,
    this.buttonHeight = 54,
    this.buttonWidth = 38,
    this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonWidth,
      height: buttonHeight,
      child: FlatButton(
        color: color ?? AppColors.lightBlue,
        padding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
