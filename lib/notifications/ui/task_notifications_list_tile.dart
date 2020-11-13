import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';
import 'package:wallpost/notifications/entities/task_notification.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/notifications/services/single_notification_reader.dart';

class TaskNotificationsListTile extends StatefulWidget {
  final TaskNotification notification;
  TaskNotificationsListTile(this.notification);

  @override
  _TaskNotificationsListTileState createState() =>
      _TaskNotificationsListTileState();
}

class _TaskNotificationsListTileState extends State<TaskNotificationsListTile> {
  SingleNotificationReader _singleNotificationReader =
      SingleNotificationReader();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.account_circle_sharp,
        size: 36,
      ),
      title: Text(
        widget.notification.taskName,
        style: widget.notification.isRead
            ? TextStyle(
                color: AppColors.defaultColor, fontWeight: FontWeight.normal)
            : TextStyle(
                color: AppColors.defaultColor, fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('Created On : ',
                style: TextStyle(color: Colors.black, fontSize: 12)),
            Text(_convertToDateFormat(widget.notification.createdAt),
                style: TextStyle(color: Colors.grey, fontSize: 12))
          ]),
          Text(widget.notification.status,
              style: TextStyle(
                color: Colors.orange,
                fontSize: 12,
              )),
        ],
      ),
      trailing: Icon(Icons.arrow_forward_ios_outlined),
      onTap: () {
        setState(() {
          widget.notification.isRead = true;
          _readSingleNotification(widget.notification);
        });
      },
    ));
  }

  String _convertToDateFormat(DateTime date) {
    var selectedCompany =
        SelectedCompanyProvider().getSelectedCompanyForCurrentUser();
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
