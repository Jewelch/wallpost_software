import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';

class AttendanceRectangleRoundedActionButton extends StatelessWidget {
  final String? title;
  final String? locationAddress;
  final String? time;
  final Color? attendanceButtonColor;
  final Color? moreButtonColor;
  final VoidCallback onButtonPressed;
  final VoidCallback onMoreButtonPressed;

  AttendanceRectangleRoundedActionButton({
    required this.title,
    required this.locationAddress,
    required this.time,
    required this.attendanceButtonColor,
    required this.moreButtonColor,
    required this.onButtonPressed,
    required this.onMoreButtonPressed,
  });

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
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                  SizedBox(height: 8),
                  Text(
                    locationAddress!,
                    style: TextStyles.subTitleTextStyle.copyWith(color: Colors.purple),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                ],
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child:
                    Text(time!, style: TextStyles.titleTextStyle.copyWith(color: Colors.white))),
            ]),
            onPressed: onButtonPressed,
          ),
        ),
      ],
    );
  }
}
