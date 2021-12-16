// @dart=2.9

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/_common_widgets/app_bars/wp_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_icon_button.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/leave/entities/leave_list_item.dart';
import 'package:wallpost/leave/entities/leave_status.dart';

class LeaveListDetailsScreen extends StatefulWidget {
  @override
  _LeaveListDetailsScreenState createState() => _LeaveListDetailsScreenState();
}

class _LeaveListDetailsScreenState extends State<LeaveListDetailsScreen> {
  LeaveListItem _leaveListItem;
  @override
  Widget build(BuildContext context) {
    _leaveListItem = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WPAppBar(
        title:
            SelectedCompanyProvider().getSelectedCompanyForCurrentUser().name,
        leading: CircularIconButton(
          iconName: 'assets/icons/back_icon.svg',
          iconSize: 15,
          onPressed: () => Navigator.pop(context),
        ),
        trailing: CircularIconButton(
            iconName: 'assets/icons/filters_icon.svg',
            iconSize: 15,
            onPressed: () => {}),
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 8),
            child: Text('Leave Requests', style: TextStyles.titleTextStyle),
          ),
          SizedBox(height: 8),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: _buildLeaveDetailsView(),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: _buildLeaveDetailsViewList(),
          ),
        ],
      )),
    );
  }

  Widget _buildLeaveDetailsView() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Column(
            children: <Widget>[
              CircleAvatar(
                radius: 20.0,
                backgroundImage:
                    NetworkImage(_leaveListItem.applicantProfileImageUrl),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(height: 4),
              Text(
                '${_leaveListItem.totalLeaveDays}',
                style: TextStyles.labelTextStyle,
              ),
              Text(
                '${_leaveListItem.totalLeaveDays == 0 || _leaveListItem.totalLeaveDays > 1 ? 'Days' : 'Day'}',
                style: TextStyles.labelTextStyle.copyWith(color: Colors.black),
              )
            ],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_leaveListItem.applicantName,
                          style: TextStyles.subTitleTextStyle),
                      Text(
                        _leaveListItem.status.stringValue(),
                        style: TextStyles.labelTextStyle.copyWith(
                            color: _leaveListItem.status.colorValue()),
                      ),
                    ]),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Contact on Leave: ',
                            style: TextStyles.labelTextStyle
                                .copyWith(color: Colors.black),
                          ),
                          TextSpan(
                              text: '+974 30821038',
                              style: TextStyles.labelTextStyle)
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Email: ',
                              style: TextStyles.labelTextStyle
                                  .copyWith(color: Colors.black),
                            ),
                            TextSpan(
                                text: 'jaseelkt09@gmail.com',
                                style: TextStyles.labelTextStyle)
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.defaultColor),
                        child: Text(
                            _leaveListItem.leaveType.replaceAll('Leave', ''),
                            textAlign: TextAlign.center,
                            style: TextStyles.labelTextStyle.copyWith(
                              color: Colors.white,
                            )),
                      ),
                    ])
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLeaveDetailsViewList() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Start:',
                textAlign: TextAlign.left,
                style: TextStyles.labelTextStyle.copyWith(color: Colors.black),
              ),
            ),
            Expanded(
              child: Text(
                _convertToDateFormat(_leaveListItem.leaveFrom),
                textAlign: TextAlign.left,
                style: TextStyles.labelTextStyle,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text('End:',
                  textAlign: TextAlign.left,
                  style:
                      TextStyles.labelTextStyle.copyWith(color: Colors.black)),
            ),
            Expanded(
              child: Text(
                _convertToDateFormat(_leaveListItem.leaveTo),
                textAlign: TextAlign.left,
                style: TextStyles.labelTextStyle,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Paid: ',
                      style: TextStyles.labelTextStyle
                          .copyWith(color: Colors.black),
                    ),
                    TextSpan(
                      text: '0 Days',
                      style: TextStyles.labelTextStyle,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Unpaid: ',
                      style: TextStyles.labelTextStyle
                          .copyWith(color: Colors.black),
                    ),
                    TextSpan(
                      text: '1 Days',
                      style: TextStyles.labelTextStyle,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                'Exit Permit Required:',
                textAlign: TextAlign.left,
                style: TextStyles.labelTextStyle.copyWith(color: Colors.black),
              ),
            ),
            Expanded(
              child: Text(
                'Yes',
                textAlign: TextAlign.left,
                style: TextStyles.labelTextStyle,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                'Departure flight:',
                textAlign: TextAlign.left,
                style: TextStyles.labelTextStyle.copyWith(color: Colors.black),
              ),
            ),
            Expanded(
              child: Text(
                'Not applicable',
                textAlign: TextAlign.left,
                style: TextStyles.labelTextStyle,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                'Handover:',
                textAlign: TextAlign.left,
                style: TextStyles.labelTextStyle.copyWith(color: Colors.black),
              ),
            ),
            Expanded(
              child: Text(
                'Not initiated',
                textAlign: TextAlign.left,
                style: TextStyles.labelTextStyle,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                'Clearance:',
                textAlign: TextAlign.left,
                style: TextStyles.labelTextStyle.copyWith(color: Colors.black),
              ),
            ),
            Expanded(
              child: Text(
                'Not initiated',
                textAlign: TextAlign.left,
                style: TextStyles.labelTextStyle,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                'Reason:',
                textAlign: TextAlign.left,
                style: TextStyles.labelTextStyle.copyWith(color: Colors.black),
              ),
            ),
            Expanded(
              child: Text(
                'Stomach pain',
                textAlign: TextAlign.left,
                style: TextStyles.labelTextStyle,
              ),
            ),
          ],
        ),
      ],
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
