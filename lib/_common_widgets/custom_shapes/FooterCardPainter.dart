
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FooterCardPainter extends CustomPainter {
  final Color color;

  FooterCardPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();



    paint.color = color;
    path = Path();
    path.lineTo(0,0);
    path.cubicTo(0, 0, 0, 30, 0, 30);
    path.lineTo(size.width - 60, 30);
    path.cubicTo(size.width, 30, size.width, -30, size.width, -40);
    path.lineTo(size.width, size.height - 60);
    path.cubicTo(size.width, size.height - 30, size.width + 30, size.height - 30, size.width + 30, size.height + 30);
    path.lineTo(-20, size.height + 30);
    path.cubicTo(0, size.height + 30, 0, size.height, 0, size.height);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}