import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class RoundedIconButton extends StatelessWidget {
  final String iconName;
  final double iconSize;
  final Color? iconColor;
  final double width;
  final double height;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  RoundedIconButton({
    required this.iconName,
    this.iconSize = 20,
    this.iconColor = Colors.white,
    this.width = 50,
    this.height = 40,
    this.backgroundColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return (backgroundColor ?? AppColors.defaultColor).withOpacity(0.5);
              } else {
                return backgroundColor ?? AppColors.defaultColor;
              }
            },
          ),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0))),
          padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
        ),
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
