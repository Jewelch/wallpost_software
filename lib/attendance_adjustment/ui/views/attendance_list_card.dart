import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/buttons/circular_icon_button.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';

class AttendanceListCard extends StatefulWidget {
  final AttendanceListItem attendanceListItem;
  final VoidCallback onPressed;

  const AttendanceListCard(
      {required this.attendanceListItem, required this.onPressed});

  @override
  State<AttendanceListCard> createState() => _AttendanceListCardState();
}

class _AttendanceListCardState extends State<AttendanceListCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.attendanceListItem.getReadableDate(),
                    style: TextStyle(color: AppColors.defaultColorDark),
                  ),
                  Text(widget.attendanceListItem.getStatus(),
                      style: TextStyle(
                          color: widget.attendanceListItem.getStatusColor())),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Text('Punch In',
                              style: TextStyle(
                                  color: widget.attendanceListItem
                                      .getPunchInLabelColor())),
                          Text(widget.attendanceListItem.originalPunchInTime,
                              style: TextStyle(color: AppColors.labelColor))
                        ],
                      ),
                      SizedBox(
                        width: 46,
                      ),
                      Column(
                        children: [
                          Text('Punch Out',
                              style: TextStyle(
                                  color: widget.attendanceListItem
                                      .getPunchOutLabelColor())),
                          Text(widget.attendanceListItem.originalPunchOutTime,
                              style: TextStyle(color: AppColors.labelColor))
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Adjust',
                          style: TextStyle(color: AppColors.defaultColorDark)),
                      CircularIconButton(
                        iconName: 'assets/icons/right_arrow_icon.svg',
                        color: Colors.white,
                        iconSize: 14,
                        iconColor: AppColors.defaultColor,
                        onPressed: widget.onPressed,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
