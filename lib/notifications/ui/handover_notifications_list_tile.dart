import 'package:flutter/material.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/notifications/entities/handover_notification.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
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
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.account_circle_sharp,
        size: 36,
      ),
      title: Text(
        widget.notification.title,
        style: TextStyle(color: AppColors.defaultColor),
      ),
      subtitle: Text(
        widget.notification.message,
      ),
      trailing: Icon(Icons.arrow_forward_ios_outlined),
      onTap: () => {_readSingleNotification(widget.notification)},
    ));
  }

  void _readSingleNotification(notification) async {
    setState(() {
      showError = false;
    });

    try {
      _singleNotificationReader.markAsRead(notification);
    } on WPException catch (_) {
      setState(() => showError = true);
    }
  }
}
