import 'package:flutter/material.dart';
import 'package:wallpost/attendance_punch_in_out/ui/text_clock.dart';
import 'package:wallpost/attendance_punch_in_out/ui/text_timer.dart';

class DisableAttendanceButtonWithTimer extends StatelessWidget {
  final VoidCallback onTimerFinished;
  final int secondsToPunchIn;

  DisableAttendanceButtonWithTimer({
    required this.onTimerFinished,
    required this.secondsToPunchIn,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return Stack(
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
          decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
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
              TextTimer(
                secondsToPunchIn: secondsToPunchIn,
                onTimerFinished: onTimerFinished,
              )
            ],
          ),
        ),
      ],
    );
  }
}
