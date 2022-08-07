import 'package:flutter/material.dart';

import '../../_shared/constants/app_colors.dart';
import 'header_card_painter.dart';

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
            color: AppColors.defaultColor.withOpacity(0.03),
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
