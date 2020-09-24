import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class RoundedIconButton extends StatelessWidget {
  final double buttonSize;
  final String iconName;
  final double iconSize;
  final VoidCallback onPressed;

  RoundedIconButton({this.buttonSize = 32, this.iconName, this.iconSize = 16, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonSize,
      height: buttonSize,
      child: FlatButton(
        color: AppColors.defaultColor,
        padding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
        child: SvgPicture.asset(
          iconName,
          width: iconSize,
          height: iconSize,
          color: Colors.white,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
