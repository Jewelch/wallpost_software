import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
class TextClock extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _TextClockState();
  }

}
class _TextClockState extends State<TextClock>{
  double seconds;

  @override
  void initState() {
    super.initState();
    seconds = DateTime.now().second / 60;
    _triggerUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_currentTime(),style: TextStyle(color: AppColors.white, fontSize: 13),);
  }


  _triggerUpdate() {
    Timer.periodic(
        Duration(seconds: 60),
            (Timer timer) => setState(
              () {
            seconds = DateTime.now().second / 60;
          },
        ));
  }

   _currentTime() {
    final DateTime now = DateTime.now();
    return _formatDateTime(now);

  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm: a').format(dateTime);
  }
}