import 'package:flutter/material.dart';
import 'package:wallpost/notifications/entities/handover_notification.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class HandoverNotificationsListTile extends StatefulWidget {
  final HandoverNotification notification;
  HandoverNotificationsListTile(this.notification);

  @override
  _HandoverNotificationsListTileState createState() =>
      _HandoverNotificationsListTileState();
}

class _HandoverNotificationsListTileState
    extends State<HandoverNotificationsListTile> {
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
        'Titile',
        style: TextStyle(color: AppColors.defaultColor),
      ),
      subtitle: Text(
        'body',
      ),
      trailing: Icon(Icons.arrow_forward_ios_outlined),
    ));
  }
}
