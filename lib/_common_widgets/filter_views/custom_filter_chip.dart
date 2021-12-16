// @dart=2.9

import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

enum CustomFilterChipShape {
  roundedRectangle,
  capsule,
}

class CustomFilterChip extends StatelessWidget {
  final Text title;
  final Widget icon;
  final Color backgroundColor;
  final Color borderColor;
  final CustomFilterChipShape shape;
  final VoidCallback onPressed;

  CustomFilterChip({
    this.title,
    this.icon,
    Color backgroundColor,
    this.borderColor,
    this.shape,
    this.onPressed,
  }) : this.backgroundColor = backgroundColor ?? AppColors.primaryContrastColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: RaisedButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            title,
            if (icon != null) SizedBox(width: 8),
            if (icon != null)
              SizedBox(
                width: 14,
                height: 14,
                child: icon,
              ),
          ],
        ),
        color: backgroundColor ?? AppColors.primaryContrastColor,
        shape: _buildBorder(),
        onPressed: onPressed,
        elevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
      ),
    );
  }

  ShapeBorder _buildBorder() {
    double borderRadius = 0;
    if (shape == CustomFilterChipShape.roundedRectangle) borderRadius = 5.0;
    if (shape == CustomFilterChipShape.capsule) borderRadius = 100.0;

    return RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(borderRadius),
      side: BorderSide(
        color: borderColor ?? this.backgroundColor,
        width: .5,
      ),
    );
  }
}
