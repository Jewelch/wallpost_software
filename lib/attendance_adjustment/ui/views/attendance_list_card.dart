import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/attendance__core/entities/attendance_status.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';
import 'package:wallpost/attendance_adjustment/ui/presenters/attendance_list_presenter.dart';

class AttendanceListCard extends StatelessWidget {
  final AttendanceListPresenter presenter;
  final AttendanceListItem attendanceListItem;
  final VoidCallback onPressed;

  final Color labelColor = Colors.yellow;
  final Color borderColor = Color.fromARGB(255, 245, 245, 245);

  AttendanceListCard({
    required this.presenter,
    required this.attendanceListItem,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: EdgeInsets.all(12),
        decoration:
            BoxDecoration(border: Border.all(color: borderColor), borderRadius: BorderRadiusDirectional.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      attendanceListItem.getReadableMonthOfDate(),
                      style: TextStyles.subTitleTextStyle.copyWith(color: Colors.grey),
                    ),
                    SizedBox(height: 4),
                    Text(
                      attendanceListItem.getReadableDate(),
                      style: TextStyles.labelTextStyleBold.copyWith(
                        color: AppColors.defaultColorDark,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      dayAndTime(),
                      style: TextStyles.labelTextStyleBold,
                    ),
                    SizedBox(height: 4),
                    Text(
                      attendanceListItem.status.toReadableString(),
                      style: TextStyles.labelTextStyle
                          .copyWith(color: presenter.getStatusColorForItem(attendanceListItem)),
                    ),
                  ],
                ),
              ],
            ),
            RoundedIconButton(
              iconName: 'assets/icons/right_arrow_icon.svg',
              backgroundColor: Colors.white,
              iconSize: 24,
              width: 16,
              height: 16,
              iconColor: Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }

  String dayAndTime() {
    if (attendanceListItem.status.toReadableString() != 'Absent') {
      return '${attendanceListItem.getReadableDayOfDate()}, ${attendanceListItem.originalPunchInTime} to ${attendanceListItem.originalPunchOutTime}';
    } else {
      return '${attendanceListItem.getReadableDayOfDate()}';
    }
  }
}
