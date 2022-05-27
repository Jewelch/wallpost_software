import 'package:flutter/material.dart';

import '../../_shared/constants/app_colors.dart';
import 'HeaderCardPainter.dart';

class HeaderCard extends StatelessWidget {
  final Widget content;
  final Color color;

  HeaderCard({required this.content, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 280,
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.defaultColor.withOpacity(0.02),
            offset: Offset(0, 0),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: CustomPaint(
        painter: HeaderCardPainter(color),
        child: content,
      ),
    );
  }
}

