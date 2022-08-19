import 'package:flutter/material.dart';

import '../../_shared/constants/app_colors.dart';

class HeaderCard extends StatelessWidget {
  final Widget content;
  final Color color;

  HeaderCard({required this.content, this.color = AppColors.defaultColorDark});

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
    path.cubicTo(0, 0, 0, 30, 20, 30);
    path.lineTo(size.width - 30, 30);
    path.cubicTo(size.width, 30, size.width, 60, size.width, 60);
    path.lineTo(size.width, size.height - 60);
    path.cubicTo(size.width, size.height - 30, size.width - 30, size.height - 30, size.width - 30, size.height - 30);
    path.lineTo(20, size.height - 30);
    path.cubicTo(0, size.height - 30, 0, size.height, 0, size.height);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
