import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

enum CustomFilterChipShape {
  roundedRectangle,
  capsule,
}

class CustomFilterChip extends StatelessWidget {
  final Text title;
  final Widget? icon;
  final Color backgroundColor;
  final Color borderColor;
  final CustomFilterChipShape shape;
  final VoidCallback? onPressed;

  CustomFilterChip({
    required this.title,
    this.icon,
    Color backgroundColor = AppColors.filtersBackgroundColour,
    this.borderColor = AppColors.defaultColorDark,
    this.shape = CustomFilterChipShape.roundedRectangle,
    this.onPressed,
  }) : this.backgroundColor = backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: MaterialButton(
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
        color: backgroundColor,
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
    if (shape == CustomFilterChipShape.roundedRectangle) borderRadius = 12.0;
    if (shape == CustomFilterChipShape.capsule) borderRadius = 100.0;

    return RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(borderRadius),
      side: BorderSide(
        color: borderColor,
        width: 1,
      ),
    );
  }
}
