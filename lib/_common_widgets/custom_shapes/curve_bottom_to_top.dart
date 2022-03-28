import 'package:flutter/material.dart';

class CurveBottomToTop extends StatelessWidget {

  CurveBottomToTop();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260,
      margin: EdgeInsets.only(right: 20),
      child: CustomPaint(
        painter: _HeaderCardPainter(),
      ),
    );
  }
}

class _HeaderCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    paint.color = Color(0xff003C81);
    path = Path();
    path.lineTo(30, 30);
    path.cubicTo(0, size.height - 30, 0, size.height, 0, size.height); //bottom left curve


    // path.cubicTo(0, 0, 0, 30, 20, 30);
    path.lineTo(size.width - 30, 30);
    // path.cubicTo(size.width, 30, size.width, 60, size.width, 60);
    // path.lineTo(size.width, size.height - 60);
    // path.cubicTo(size.width, size.height - 30, size.width - 30, size.height - 30, size.width - 30, size.height - 30);
    // path.lineTo(20, size.height - 30);

    path.lineTo(0, 0); //back to top
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
