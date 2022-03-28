import 'package:flutter/material.dart';

class TextTimer extends StatefulWidget {
  final TextTimerState _state;

  TextTimer({
    required int secondsToPunchIn,
    required VoidCallback onTimerFinished,
  }) : _state = TextTimerState(secondsToPunchIn: secondsToPunchIn, onTimerFinished: onTimerFinished);

  @override
  State<StatefulWidget> createState() => _state;
}

class TextTimerState extends State<TextTimer> {
  int secondsToPunchIn;
  VoidCallback onTimerFinished;

  TextTimerState({
    required this.secondsToPunchIn,
    required this.onTimerFinished,
  });

  @override
  void initState() {
    super.initState();
//    _triggerUpdate();
  }

  @override
  Widget build(BuildContext context) {
//    String title = _getTime() + "\nTo Punch In";

    return Text(
      'some text',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 13,
      ),
    );
  }
//
//  _triggerUpdate() {
//    Timer.periodic(
//        Duration(seconds: 1),
//        (Timer timer) => setState(
//              () {
//                if (secondsToPunchIn <= 1) {
//                  timer.cancel();
//
//                  onTimerFinished.call();
//                }
//                secondsToPunchIn = secondsToPunchIn - 1;
//              },
//            ));
//  }
//
//  String _getTime() {
//    String duration = TimeToPunchInCalculator.timeTillPunchIn(secondsToPunchIn);
//    return duration;
//  }
}
