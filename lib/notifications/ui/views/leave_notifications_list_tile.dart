import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/notifications/entities/leave_notification.dart';
import 'package:wallpost/notifications/services/single_notification_reader.dart';

class LeaveNotificationsListTile extends StatefulWidget {
  final LeaveNotification notification;

  LeaveNotificationsListTile(this.notification);

  @override
  _LeaveNotificationsListTileState createState() => _LeaveNotificationsListTileState();
}

class _LeaveNotificationsListTileState extends State<LeaveNotificationsListTile> {
  SingleNotificationReader _singleNotificationReader = SingleNotificationReader();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 4),
        leading: Icon(Icons.account_circle_sharp, size: 36),
        title: Text(
          widget.notification.title,
          style: TextStyles.subTitleTextStyle.copyWith(
              color: AppColors.defaultColor,
              fontWeight: widget.notification.isRead ? FontWeight.normal : FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Requested By : ',
                        style: TextStyles.labelTextStyle.copyWith(color: Colors.black),
                      ),
                      TextSpan(text: widget.notification.applicantName, style: TextStyles.labelTextStyle),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_outlined, color: Colors.grey, size: 14)
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'From : ',
                        style: TextStyles.labelTextStyle.copyWith(color: Colors.black),
                      ),
                      TextSpan(
                          text: _convertToDateFormat(widget.notification.leaveFrom), style: TextStyles.labelTextStyle)
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: 'To : ', style: TextStyles.labelTextStyle.copyWith(color: Colors.black)),
                      TextSpan(
                          text: _convertToDateFormat(widget.notification.leaveTo), style: TextStyles.labelTextStyle)
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.defaultColor),
                  child: Text(
                    widget.notification.leaveType,
                    style: TextStyles.labelTextStyle.copyWith(color: Colors.white),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: 'Request On : ', style: TextStyles.labelTextStyle.copyWith(color: Colors.black)),
                      TextSpan(
                          text: _convertToDateFormat(widget.notification.createdAt), style: TextStyles.labelTextStyle)
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          setState(() {
            widget.notification.markAsRead();
            _readSingleNotification(widget.notification);
          });
        },
      ),
    );
  }

  String _convertToDateFormat(DateTime date) {
    var selectedCompany = SelectedCompanyProvider().getSelectedCompanyForCurrentUser();
    final DateFormat formatter = DateFormat();
    final String formatted = formatter.format(date);
    return formatted;
  }

  void _readSingleNotification(notification) async {
    try {
      _singleNotificationReader.markAsRead(notification);
    } on WPException catch (_) {
      setState(() => {});
    }
  }
}
