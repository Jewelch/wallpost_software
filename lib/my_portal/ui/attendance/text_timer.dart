import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/my_portal/ui/attendance/utils/date_time_util.dart';
class TextTimer extends StatefulWidget{
  double secondsToPunchIn;
  final VoidCallback onTimerFinished;


  TextTimer({this.secondsToPunchIn, this.onTimerFinished,});
  @override
  State<StatefulWidget> createState() {
    return TextTimerState(secondsToPunchIn: secondsToPunchIn,onTimerFinished:onTimerFinished );
  }
  
}
class TextTimerState extends State<TextTimer>{
  double secondsToPunchIn;
   VoidCallback onTimerFinished;

  TextTimerState({this.secondsToPunchIn,this.onTimerFinished});

  @override
  void initState() {
    super.initState();
    _triggerUpdate();
  }

  @override
  Widget build(BuildContext context) {
    String title =  _getTime() + "\nTo Punch In";

    return Text(title,textAlign : TextAlign.center,style: TextStyle(color: AppColors.white, fontSize: 13,),);

  }
  _triggerUpdate() {
    Timer.periodic(
        Duration(seconds: 1) ,
            (Timer timer) => setState(
              () {
                if(secondsToPunchIn<=1) {
                  timer.cancel();

                  onTimerFinished.call();
                }
                secondsToPunchIn = secondsToPunchIn -1;
          },
        ));
  }
  String _getTime() {
    double timeInMilliSeconds = secondsToPunchIn * 1000;
    String duration = DateTimeUtil.convertMilliSecondsToReadableTime(timeInMilliSeconds);
     return  duration;


  }

  
}