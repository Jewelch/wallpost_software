// @dart=2.9

import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/attendance/ui/text_clock.dart';

class AttendanceButtonView extends StatelessWidget {
  final String name;
  final Color color;
  final VoidCallback onPressed;

  AttendanceButtonView({this.name, this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 140,
            width: 140,
            decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            height: 135,
            width: 135,
            decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
          ),
          Container(
            height: 115,
            width: 115,
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
          Container(
            height: 113,
            width: 113,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          Container(
            child: Column(
              children: [
                TextClock(),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: 50,
                  height: 1,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
