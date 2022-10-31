import 'package:flutter/material.dart';

import '../../../../_shared/constants/app_colors.dart';

class PerformanceViewHolder extends StatelessWidget {
  final Widget content;
  final Color backgroundColor;

  PerformanceViewHolder({
    required this.content,
    this.backgroundColor = AppColors.screenBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.defaultColorDarkContrastColor.withOpacity(0.3),
            offset: Offset(0, 0),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: content,
    );
  }
}
