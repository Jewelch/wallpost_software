import 'package:flutter/material.dart';
import 'package:wallpost/authentication/services/logout_handler.dart';
import 'package:wallpost/notifications/entities/leave_notification.dart';
import 'package:wallpost/notifications/entities/task_notification.dart';
import 'package:wallpost/notifications/services/notifications_list_provider.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Text('Notifications Screen'),
              FlatButton(
                color: Colors.red,
                child: Text('Logout'),
                onPressed: () {
                  LogoutHandler().logout(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void asdf() async {
    var nlp = NotificationsListProvider();
    var a = await nlp.getNext();

    var notif = a[0];
    if (notif.isATaskNotification) {
      var view = TaskNotificationListTile(notif);
    } else if (notif.isALeaveNotification) {
      var view = LeaveNotificationListTile(notif);
    }
  }
}

/*
what to show
for handover - full body and datetime
for task - title status and datetime
for leave - title applicant type to and from and datetime
for expense - title amount applicant and datetime
 */

class TaskNotificationListTile extends StatelessWidget {
  final TaskNotification notification;

  TaskNotificationListTile(this.notification);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Text(notification.taskName),
        Text(notification.status),
        Text('${notification.createdAt.toString()} format using company date format'),
      ],
    ));
  }
}

class LeaveNotificationListTile extends StatelessWidget {
  final LeaveNotification notification;

  LeaveNotificationListTile(this.notification);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Text(notification.title),
        Text(notification.applicantName),
        Text(notification.leaveType),
        Text('${notification.leaveFrom.toString()} format using company date format'),
        Text('${notification.leaveTo.toString()} format using company date format'),
        Text('${notification.createdAt.toString()} format using company date format'),
      ],
    ));
  }
}
