import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/leave/entities/leave_list_item.dart';
import 'package:wallpost/leave/entities/leave_status.dart';

class LeaveListTile extends StatelessWidget {
  final LeaveListItem leaveListItem;
  final VoidCallback onLeaveListTileTap;

  const LeaveListTile(this.leaveListItem, {this.onLeaveListTileTap});

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: InkWell(
        onTap: () => {onLeaveListTileTap()},
        child: Row(
          children: [
            Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(leaveListItem.applicantProfileImageUrl),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(height: 4),
                Text(
                  leaveListItem.totalLeaveDays.toString(),
                  style: TextStyles.labelTextStyle,
                ),
                Text(
                  'Days',
                  style: TextStyles.labelTextStyle.copyWith(color: Colors.black),
                )
              ],
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    leaveListItem.applicantName,
                    style: TextStyles.subTitleTextStyle.copyWith(
                      color: AppColors.defaultColor,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Start: ',
                              style: TextStyles.labelTextStyle.copyWith(color: Colors.black),
                            ),
                            TextSpan(
                              text: _convertToDateFormat(
                                leaveListItem.leaveFrom,
                              ),
                              style: TextStyles.labelTextStyle,
                            )
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'End: ',
                              style: TextStyles.labelTextStyle.copyWith(color: Colors.black),
                            ),
                            TextSpan(
                              text: _convertToDateFormat(
                                leaveListItem.leaveTo,
                              ),
                              style: TextStyles.labelTextStyle,
                            )
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_outlined, color: Colors.grey, size: 14),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.defaultColor),
                      child: Text(
                        leaveListItem.leaveType,
                        style: TextStyles.labelTextStyle.copyWith(color: Colors.white),
                      ),
                    ),
                    Text(
                      leaveListItem.status.stringValue(),
                      style: TextStyles.labelTextStyle.copyWith(color: leaveListItem.status.colorValue()),
                    ),
                  ])
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String _convertToDateFormat(DateTime date) {
    var selectedCompany = SelectedCompanyProvider().getSelectedCompanyForCurrentUser();
    final DateFormat formatter = DateFormat(selectedCompany.dateFormat);
    final String formatted = formatter.format(date);
    return formatted;
  }
}
