import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/notifications/entities/leave_notification.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class LeaveNotificationsListTile extends StatefulWidget {
  final LeaveNotification notification;

  LeaveNotificationsListTile(this.notification);

  @override
  _LeaveNotificationsListTileState createState() =>
      _LeaveNotificationsListTileState();
}

class _LeaveNotificationsListTileState extends State<LeaveNotificationsListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.account_circle_sharp, size: 36),
      title: Text(
        widget.notification.title,
        style: TextStyle(color: AppColors.defaultColor),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'Requested By : ',
                  style: TextStyle(color: Colors.black, fontSize: 12)),
              TextSpan(
                  text: widget.notification.applicantName,
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
            ])),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.grey,
            )
          ]),
          SizedBox(height: 4),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.defaultColor),
              child: Text(
                widget.notification.leaveType,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'Request On : ',
                    style: TextStyle(color: Colors.black, fontSize: 12)),
                TextSpan(
                    text:
                        convertToDate(widget.notification.createdAt.toString()),
                    style: TextStyle(color: Colors.grey, fontSize: 12))
              ]),
            )
          ]),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: 'From : ',
                      style: TextStyle(color: Colors.black, fontSize: 12)),
                  TextSpan(
                      text: convertToDate(
                          widget.notification.leaveFrom.toString()),
                      style: TextStyle(color: Colors.grey, fontSize: 12))
                ]),
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: 'To : ',
                      style: TextStyle(color: Colors.black, fontSize: 12)),
                  TextSpan(
                      text:
                          convertToDate(widget.notification.leaveTo.toString()),
                      style: TextStyle(color: Colors.grey, fontSize: 12))
                ]),
              )
            ],
          )
        ],
      ),
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
