import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/notifications/entities/task_notification.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class TaskNotificationsListTile extends StatefulWidget {
  final TaskNotification notification;
  TaskNotificationsListTile(this.notification);

  @override
  _TaskNotificationsListTileState createState() =>
      _TaskNotificationsListTileState();
}

class _TaskNotificationsListTileState extends State<TaskNotificationsListTile> {
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
        style: TextStyle(color: AppColors.defaultColor),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('Created On : ',
                style: TextStyle(color: Colors.black, fontSize: 12)),
            Text(convertToDate(widget.notification.createdAt.toString()),
                style: TextStyle(color: Colors.black, fontSize: 12))
          ]),
          Text(widget.notification.status,
              style: TextStyle(
                color: Colors.orange,
                fontSize: 12,
              )),
        ],
      ),
      trailing: Icon(Icons.arrow_forward_ios_outlined),
    ));
  }

  String convertToDate(String date) {
    final DateFormat dateTimeFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat dateFormater = DateFormat('dd.MM.yyyy');
    final DateTime displayDate = dateTimeFormater.parse(date);
    final String formattedDate = dateFormater.format(displayDate);
    return formattedDate;
  }
}
