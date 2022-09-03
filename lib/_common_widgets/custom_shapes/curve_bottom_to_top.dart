import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class CurveBottomToTop extends StatelessWidget {
  CurveBottomToTop();

  @override
  Widget build(BuildContext context) {
    //we use a stack here instead of a column because
    //some times there is a thin line between the two items
    //due to a bug in flutter. So, we overlap the two items
    //using a stack to hide the thin line.
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: AppColors.defaultColor.withOpacity(0.05),
                  offset: Offset(0, 0),
                  blurRadius: 20,
                  spreadRadius: 0),
            ],
          ),
          child: CustomPaint(
            painter: _CurveBottomToTopPainter(),
          ),
        ),
        Container(margin: EdgeInsets.only(top: 56), height: 20, color: Colors.white),
      ],
    );
  }
}

class _CurveBottomToTopPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    paint.color = Colors.white;
    path = Path();
    path.moveTo(size.width, 0);
    path.cubicTo(size.width, 30, size.width - 30, 30, size.width - 30, 30);
    path.lineTo(30, 30);
    path.cubicTo(0, 30, 0, size.height, 0, size.height);
    path.lineTo(size.width, 60);
    path.lineTo(size.width, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
