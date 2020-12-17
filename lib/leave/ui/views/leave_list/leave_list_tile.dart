import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/leave/entities/leave_list_item.dart';

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
      child: Row(
        children: [
          Column(
            children: <Widget>[
              CircleAvatar(
                radius: 24.0,
                backgroundImage:
                    NetworkImage(widget.leaveListItem.applicantProfileImageUrl),
                backgroundColor: Colors.transparent,
              ),
              Text(widget.leaveListItem.totalLeaveDays.toString(),
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text('Days', style: TextStyle(fontSize: 14))
            ],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.leaveListItem.applicantName,
                  style: TextStyle(color: AppColors.defaultColor),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'Start : ',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12)),
                          TextSpan(
                              text: _convertToDateFormat(
                                  widget.leaveListItem.leaveFrom),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12))
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'End : ',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12)),
                          TextSpan(
                              text: _convertToDateFormat(
                                  widget.leaveListItem.leaveTo),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12))
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_outlined,
                        color: Colors.grey, size: 14),
                  ],
                ),
                SizedBox(height: 8),
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
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      Text(
                        widget.leaveListItem.status.toString(),
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                        ),
                      ),
                    ])
              ],
            ),
          )
        ],
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
