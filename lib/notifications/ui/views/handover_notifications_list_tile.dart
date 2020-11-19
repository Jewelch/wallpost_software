import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';
import 'package:wallpost/notifications/entities/handover_notification.dart';
import 'package:wallpost/notifications/services/single_notification_reader.dart';

class HandoverNotificationsListTile extends StatefulWidget {
  final HandoverNotification notification;

  HandoverNotificationsListTile(this.notification);

  @override
  _HandoverNotificationsListTileState createState() =>
      _HandoverNotificationsListTileState();
}

class _HandoverNotificationsListTileState
    extends State<HandoverNotificationsListTile> {
  SingleNotificationReader _singleNotificationReader =
      SingleNotificationReader();
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.only(top: 4),
        leading: Icon(Icons.account_circle_sharp, size: 36),
        title: Text(
          widget.notification.title,
          style: TextStyle(color: AppColors.defaultColor),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(widget.notification.message),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'Date: ',
                      style: TextStyle(color: Colors.black, fontSize: 12)),
                  TextSpan(
                      text: _convertToDateFormat(widget.notification.createdAt),
                      style: TextStyle(color: Colors.grey, fontSize: 12))
                ],
              ),
            )
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios_outlined,
            color: Colors.grey, size: 14),
        onTap: () => _readSingleNotification(widget.notification),
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

  void _readSingleNotification(notification) async {
    setState(() => showError = false);

    try {
      _singleNotificationReader.markAsRead(notification);
    } on WPException catch (_) {
      setState(() => showError = true);
    }
  }
}
