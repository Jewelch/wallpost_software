import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/notifications/entities/task_notification.dart';
import 'package:wallpost/notifications/services/single_notification_reader.dart';

class TaskNotificationsListTile extends StatefulWidget {
  final TaskNotification notification;

  TaskNotificationsListTile(this.notification);

  @override
  _TaskNotificationsListTileState createState() => _TaskNotificationsListTileState();
}

class _TaskNotificationsListTileState extends State<TaskNotificationsListTile> {
  SingleNotificationReader _singleNotificationReader = SingleNotificationReader();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 4),
      leading: Icon(Icons.account_circle_sharp, size: 36),
      title: Text(
        widget.notification.taskName,
        style: TextStyles.subTitleTextStyle.copyWith(
          color: AppColors.defaultColor,
          fontWeight: widget.notification.isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Created On : ',
                style: TextStyles.labelTextStyle.copyWith(color: Colors.black),
              ),
              Text(_convertToDateFormat(widget.notification.createdAt), style: TextStyles.labelTextStyle)
            ],
          ),
          SizedBox(height: 8),
          Text(
            widget.notification.status,
            style: TextStyles.labelTextStyle.copyWith(color: Colors.orange),
          ),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(Icons.arrow_forward_ios_outlined, color: Colors.grey, size: 14)],
      ),
      onTap: () {
        setState(() {
          widget.notification.markAsRead();
          _readSingleNotification(widget.notification);
        });
      },
    ));
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
