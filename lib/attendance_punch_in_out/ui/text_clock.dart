
import 'package:flutter/material.dart';

class TextClock extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TextClockState();
  }
}

class _TextClockState extends State<TextClock> {
  double seconds = 100;

//  @override
//  void initState() {
//    super.initState();
//    seconds = DateTime.now().second / 60;
//    _triggerUpdate();
//  }

  @override
  Widget build(BuildContext context) {
    return Text('some text');
  }

//  _triggerUpdate() {
//    Timer.periodic(
//        Duration(seconds: 60),
//            (Timer timer) => setState(
//              () {
//            seconds = DateTime.now().second / 60;
//          },
//        ));
//  }
//
//   _currentTime() {
//    final DateTime now = DateTime.now();
//    return _formatDateTime(now);
//
//  }
//
//  String _formatDateTime(DateTime dateTime) {
//    return DateFormat('hh:mm: a').format(dateTime);
//  }
}
