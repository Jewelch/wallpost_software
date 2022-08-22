import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';
import 'package:wallpost/attendance_adjustment/ui/presenters/attendance_list_presenter.dart';

class AttendanceListCard extends StatelessWidget {
  final AttendanceListPresenter presenter;
  final AttendanceListItem attendanceListItem;
  final VoidCallback onPressed;

  final Color labelColor = Colors.yellow;

  AttendanceListCard({
    required this.presenter,
    required this.attendanceListItem,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: InkWell(
        onTap: onPressed,
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 1, color: AppColors.listItemBorderColor),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  SizedBox(height: 2),
                  Text(
                    presenter.getMonth(attendanceListItem),
                    style: TextStyles.labelTextStyle,
                  ),
                  SizedBox(height: 4),
                  Text(
                    presenter.getDay(attendanceListItem),
                    style: TextStyles.titleTextStyleBold.copyWith(color: AppColors.defaultColorDark),
                  ),
                ],
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      presenter.getListItemTitle(attendanceListItem),
                      style: TextStyles.subTitleTextStyleBold,
                    ),
                    SizedBox(height: 4),
                    Text(
                      presenter.getStatus(attendanceListItem),
                      style: TextStyles.labelTextStyle.copyWith(
                        color: presenter.getStatusColorForItem(attendanceListItem),
                      ),
                    ),
                    if (presenter.getApprovalInfo(attendanceListItem).isNotEmpty) SizedBox(height: 8),
                    if (presenter.getApprovalInfo(attendanceListItem).isNotEmpty)
                      Text(
                        presenter.getApprovalInfo(attendanceListItem),
                        style: TextStyles.subTitleTextStyle.copyWith(
                          color: AppColors.red,
                        ),
                      ),
                  ],
                ),
              ),
              RoundedIconButton(
                iconName: 'assets/icons/arrow_right_icon.svg',
                backgroundColor: Colors.white,
                iconSize: 24,
                width: 16,
                height: 16,
                iconColor: Colors.blueGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
