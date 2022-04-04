import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class AttendanceRoundedActionButton extends StatelessWidget {
  final String? title;
  final String? time;
  final Color? buttonColor;
  final VoidCallback onButtonPressed;

  AttendanceRoundedActionButton({
    this.title,
    this.time,
    this.buttonColor,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      onPressed: onButtonPressed,
      color: buttonColor,
      textColor: Colors.white,
      child: Column(
        children: [
          SvgPicture.asset(
            // <-- Icon
            "assets/icons/overtime_icon.svg",
            height: 18,
            color: Colors.white,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            title!,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            time!,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )
        ],
      ),
      padding: EdgeInsets.all(30),
      shape: CircleBorder(),
    );
  }
}
