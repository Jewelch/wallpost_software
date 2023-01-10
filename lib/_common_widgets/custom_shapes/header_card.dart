import 'package:flutter/material.dart';

import '../../_shared/constants/app_colors.dart';

class HeaderCard extends StatelessWidget {
  final Widget content;
  final double height;
  final Color color;

  HeaderCard({required this.content, this.height = 260.0, this.color = AppColors.defaultColorDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
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

class HeaderCardPainter extends CustomPainter {
  final Color color;

  HeaderCardPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    paint.color = color;
    path = Path();
    path.lineTo(0, 0);
    path.cubicTo(0, 0, 0, 24, 24, 24);
    path.lineTo(size.width - 24, 24);
    path.cubicTo(size.width, 24, size.width, 48, size.width, 48);
    path.lineTo(size.width, size.height - 48);
    path.cubicTo(size.width, size.height - 24, size.width - 24, size.height - 24, size.width - 24, size.height - 24);
    path.lineTo(24, size.height - 24);
    path.cubicTo(0, size.height - 24, 0, size.height, 0, size.height);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
