
import 'package:flutter/cupertino.dart';

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
    canvas.drawShadow(path, color, 1.0, true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}