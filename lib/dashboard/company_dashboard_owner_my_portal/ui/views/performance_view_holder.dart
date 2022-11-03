import 'package:flutter/material.dart';

import '../../../../_shared/constants/app_colors.dart';

class PerformanceViewHolder extends StatelessWidget {
  final Widget content;
  final Color backgroundColor;
  final EdgeInsets padding;
  final bool showShadow;

  PerformanceViewHolder({
    required this.content,
    this.backgroundColor = AppColors.screenBackgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: AppColors.defaultColorDarkContrastColor.withOpacity(0.3),
                  offset: Offset(0, 0),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: content,
    );
  }
}
