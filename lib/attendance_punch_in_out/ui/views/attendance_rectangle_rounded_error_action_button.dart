import 'package:flutter/material.dart';

class AttendanceRectangleRoundedErrorActionButton extends StatelessWidget {
  final String? errorText;
  final VoidCallback onButtonPressed;

  AttendanceRectangleRoundedErrorActionButton({
    required this.errorText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      child: MaterialButton(
        height: 64,
        elevation: 0,
        highlightElevation: 0,
        padding: EdgeInsets.only(left: 14,right: 14),
        color: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(errorText!,style: TextStyle(color: Colors.white)),
        onPressed: onButtonPressed
      )
    );
  }
}