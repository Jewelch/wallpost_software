import 'package:flutter/material.dart';

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
      padding: EdgeInsets.all(24),
      shape: CircleBorder(),
      elevation: 0,
      color: buttonColor,
      textColor: Colors.white,
      child: Column(
        children: [
          Icon(
            Icons.access_time,
            size: 32,
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
      onPressed: onButtonPressed,
    );
  }
}
