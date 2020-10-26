import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/attendance/services/time_to_punch_in_calculator.dart';

class TextTimer extends StatefulWidget {
  final TextTimerState _state;

  TextTimer({
    int secondsToPunchIn,
    VoidCallback onTimerFinished,
  }) : _state = TextTimerState(secondsToPunchIn: secondsToPunchIn, onTimerFinished: onTimerFinished);

  @override
  State<StatefulWidget> createState() => _state;
}

class TextTimerState extends State<TextTimer> {
  int secondsToPunchIn;
  VoidCallback onTimerFinished;

  TextTimerState({this.secondsToPunchIn, this.onTimerFinished});

  @override
  void initState() {
    super.initState();
    _triggerUpdate();
  }

  @override
  Widget build(BuildContext context) {
    String title = _getTime() + "\nTo Punch In";

    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.white,
        fontSize: 13,
      ),
    );
  }

  _triggerUpdate() {
    Timer.periodic(
        Duration(seconds: 1),
        (Timer timer) => setState(
              () {
                if (secondsToPunchIn <= 1) {
                  timer.cancel();

                  onTimerFinished.call();
                }
                secondsToPunchIn = secondsToPunchIn - 1;
              },
            ));
  }

  String _getTime() {
    String duration = TimeToPunchInCalculator.timeTillPunchIn(secondsToPunchIn);
    return duration;
  }
}
