import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/leave/entities/leave_list_item.dart';
import 'package:wallpost/leave/entities/leave_status.dart';
import 'package:wallpost/leave/ui/views/Leave_list_datails/leave_list_deatils_screen.dart';

class LeaveListTile extends StatefulWidget {
  final LeaveListItem leaveListItem;

  const LeaveListTile(this.leaveListItem);

  @override
  _LeaveListTileState createState() => _LeaveListTileState();
}

class _LeaveListTileState extends State<LeaveListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 4),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (__) => new LeaveListDetailsScreen(
                  leaveListItem: widget.leaveListItem),
            ),
          );
        },
        child: Row(
          children: [
            Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(
                      widget.leaveListItem.applicantProfileImageUrl),
                  backgroundColor: Colors.transparent,
                ),
                Text(widget.leaveListItem.totalLeaveDays.toString(),
                    style: TextStyles.listSubTitleTextStyle),
                Text(
                  'Days',
                  style: TextStyles.listSubTitleTextStyle
                      .copyWith(color: Colors.black),
                )
              ],
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.leaveListItem.applicantName,
                      style: TextStyles.listTitleTextStyle),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Start : ',
                                style: TextStyles.listSubTitleTextStyle
                                    .copyWith(color: Colors.black)),
                            TextSpan(
                                text: _convertToDateFormat(
                                    widget.leaveListItem.leaveFrom),
                                style: TextStyles.listSubTitleTextStyle)
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'End : ',
                              style: TextStyles.listSubTitleTextStyle
                                  .copyWith(color: Colors.black),
                            ),
                            TextSpan(
                                text: _convertToDateFormat(
                                    widget.leaveListItem.leaveTo),
                                style: TextStyles.listSubTitleTextStyle)
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_outlined,
                          color: Colors.grey, size: 14),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.defaultColor),
                          child: Text(
                            widget.leaveListItem.leaveType,
                            style: TextStyles.smallSubTitleTextStyle
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        Text(
                          widget.leaveListItem.status.stringValue(),
                          style: TextStyles.smallSubTitleTextStyle
                              .copyWith(color: Colors.orange),
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
    var selectedCompany =
        SelectedCompanyProvider().getSelectedCompanyForCurrentUser();
    final DateFormat formatter = DateFormat(selectedCompany.dateFormat);
    final String formatted = formatter.format(date);
    return formatted;
  }
}
