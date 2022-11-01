import 'package:flutter/material.dart';

import '../../../../_shared/constants/app_colors.dart';

class PerformanceViewHolderNew extends StatelessWidget {
  final Widget content;
  final Color backgroundColor;

  PerformanceViewHolderNew({
    required this.content,
    this.backgroundColor = AppColors.screenBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
