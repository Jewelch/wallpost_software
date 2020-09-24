import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class RoundedIconButton extends StatelessWidget {
  static const double WIDTH = 56.0;
  final String iconName;
  final double iconSize;
  final VoidCallback onPressed;

  RoundedIconButton({this.iconName, this.iconSize = 18, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: WIDTH,
      padding: EdgeInsets.all(10),
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
