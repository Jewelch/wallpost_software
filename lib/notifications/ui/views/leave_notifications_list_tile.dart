import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';
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
        contentPadding: EdgeInsets.only(top: 4),
        leading: Icon(Icons.account_circle_sharp, size: 36),
        title: Text(widget.notification.title,
            style: TextStyle(
                color: AppColors.defaultColor,
                fontWeight: widget.notification.isRead ? FontWeight.normal : FontWeight.bold)),
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
                      TextSpan(text: 'Requested By : ', style: TextStyle(color: Colors.black, fontSize: 12)),
                      TextSpan(
                          text: widget.notification.applicantName, style: TextStyle(color: Colors.grey, fontSize: 12)),
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
                      TextSpan(text: 'From : ', style: TextStyle(color: Colors.black, fontSize: 12)),
                      TextSpan(
                          text: _convertToDateFormat(widget.notification.leaveFrom),
                          style: TextStyle(color: Colors.grey, fontSize: 12))
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: 'To : ', style: TextStyle(color: Colors.black, fontSize: 12)),
                      TextSpan(
                          text: _convertToDateFormat(widget.notification.leaveTo),
                          style: TextStyle(color: Colors.grey, fontSize: 12))
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
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: 'Request On : ', style: TextStyle(color: Colors.black, fontSize: 12)),
                      TextSpan(
                          text: _convertToDateFormat(widget.notification.createdAt),
                          style: TextStyle(color: Colors.grey, fontSize: 12))
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          setState(() {
            widget.notification.isRead = true;
            _readSingleNotification(widget.notification);
          });
        },
      ),
    );
  }

  String _convertToDateFormat(DateTime date) {
    var selectedCompany = SelectedCompanyProvider().getSelectedCompanyForCurrentUser();
    final DateFormat formatter = DateFormat(selectedCompany.dateFormat);
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
