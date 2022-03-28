import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/buttons/circular_icon_button.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';
import 'package:wallpost/attendance__core/entities/attendance_status.dart';
import 'package:wallpost/attendance_adjustment/ui/presenters/attendance_list_presenter.dart';

class AttendanceListCard extends StatelessWidget {
  final AttendanceListPresenter presenter;
  final AttendanceListItem attendanceListItem;
  final VoidCallback onPressed;

  AttendanceListCard({
    required this.presenter,
    required this.attendanceListItem,
    required this.onPressed,
  });

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
                    attendanceListItem.getReadableDate(),
                    style: TextStyle(color: AppColors.defaultColorDark),
                  ),
                  Text(
                    attendanceListItem.status.toReadableString(),
                    style: TextStyle(color: presenter.getStatusColorForItem(attendanceListItem)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            'Punch In',
                            style: TextStyle(color: presenter.getPunchInLabelColorForItem(attendanceListItem)),
                          ),
                          Text(attendanceListItem.originalPunchInTime, style: TextStyle(color: AppColors.labelColor))
                        ],
                      ),
                      SizedBox(
                        width: 46,
                      ),
                      Column(
                        children: [
                          Text(
                            'Punch Out',
                            style: TextStyle(color: presenter.getPunchInLabelColorForItem(attendanceListItem)),
                          ),
                          Text(attendanceListItem.originalPunchOutTime, style: TextStyle(color: AppColors.labelColor))
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Adjust', style: TextStyle(color: AppColors.defaultColorDark)),
                      CircularIconButton(
                        iconName: 'assets/icons/right_arrow_icon.svg',
                        color: Colors.white,
                        iconSize: 14,
                        iconColor: AppColors.defaultColor,
                        onPressed: onPressed,
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
