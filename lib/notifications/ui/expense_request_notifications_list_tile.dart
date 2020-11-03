import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';
import 'package:wallpost/notifications/entities/expense_request_notification.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class ExpenserequestNotificationsListTile extends StatefulWidget {
  final ExpenseRequestNotification notification;
  ExpenserequestNotificationsListTile(this.notification);

  @override
  _ExpenserequestNotificationsListTileState createState() =>
      _ExpenserequestNotificationsListTileState();
}

class _ExpenserequestNotificationsListTileState
    extends State<ExpenserequestNotificationsListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.account_circle_sharp,
        size: 36,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.notification.title,
            style: TextStyle(color: AppColors.defaultColor),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: SelectedCompanyProvider()
                      .getSelectedCompanyForCurrentUser()
                      .currency,
                  style: TextStyle(color: AppColors.defaultColor)),
              TextSpan(
                  text: widget.notification.amount,
                  style: TextStyle(
                      color: AppColors.defaultColor,
                      fontWeight: FontWeight.bold))
            ]),
          )
        ],
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
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: 'Request On : ',
                  style: TextStyle(color: Colors.black, fontSize: 12)),
              TextSpan(
                  text: convertToDate(widget.notification.createdAt.toString()),
                  style: TextStyle(color: Colors.grey, fontSize: 12))
            ]),
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
