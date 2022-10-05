import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';

class AttendanceActionButton extends StatelessWidget {
  final String title;
  final String locationAddress;
  final String time;
  final Color attendanceButtonColor;
  final Color moreButtonColor;
  final VoidCallback onButtonPressed;
  final VoidCallback onRefreshPressed;
  final VoidCallback onMoreButtonPressed;

  AttendanceActionButton({
    required this.title,
    required this.locationAddress,
    required this.time,
    required this.attendanceButtonColor,
    required this.moreButtonColor,
    required this.onButtonPressed,
    required this.onRefreshPressed,
    required this.onMoreButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
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
            onPressed: onButtonPressed,
            elevation: 0,
            highlightElevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 16),
            color: attendanceButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
              side: BorderSide(color: Colors.transparent),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyles.subTitleTextStyle.copyWith(color: Colors.white),
                      ),
                      SizedBox(height: 4),
                      Text(
                        locationAddress,
                        style: TextStyles.labelTextStyle.copyWith(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: onRefreshPressed,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(time, style: TextStyles.subTitleTextStyle.copyWith(color: Colors.white)),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text("Refresh", style: TextStyles.labelTextStyle.copyWith(color: Colors.white)),
                          SizedBox(width: 2),
                          Icon(Icons.refresh, size: 14, color: Colors.white),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
