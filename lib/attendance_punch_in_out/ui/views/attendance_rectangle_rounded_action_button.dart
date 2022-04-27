import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class AttendanceRectangleRoundedActionButton extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? time;
  final String? status;
  final Color? attendanceButtonColor;
  final Color? moreButtonColor;
  final VoidCallback onButtonPressed;
  final VoidCallback onMoreButtonPressed;

  AttendanceRectangleRoundedActionButton({
    required this.title,
    required this.subtitle,
    required this.time,
    this.status,
    required this.attendanceButtonColor,
    required this.moreButtonColor,
    required this.onButtonPressed,
    required this.onMoreButtonPressed,
  });

  //Height should be dynamic
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: 120,
            child: MaterialButton(
              elevation: 0,
              highlightElevation: 0,
              padding: EdgeInsets.only(left: 26),
              color: moreButtonColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Row(
                children: [
                  SizedBox(width: 20),
                  Icon(Icons.arrow_upward, size: 20, color: Colors.white),
                  Text(" More", style: TextStyles.subTitleTextStyle.copyWith(color: Colors.white)),
                ],
              ),
              onPressed: onMoreButtonPressed,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 80),
          child: MaterialButton(
            elevation: 0,
            highlightElevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: attendanceButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
              side: BorderSide(color: Colors.transparent),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title!,
                    style: TextStyles.titleTextStyle.copyWith(color: Colors.white),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(subtitle!, style: TextStyle(fontSize: 12, color: AppColors.locationAddressTextColor))
                ],
              ),
              Column(
                children: [
                  //  Text( _timeString!,
                  Text(time!, style: TextStyle(fontSize: 16, color: Colors.white)),
                  SizedBox(
                    height: 2,
                  ),

                  if (status == null) Text(""),
                  if (status != null)
                    Text(status!, style: TextStyle(fontSize: 12, color: AppColors.attendanceStatusColor))
                ],
              ),
            ]),
            onPressed: onButtonPressed,
          ),
        ),
      ],
    );
  }
}
