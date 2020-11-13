import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';
import 'package:wallpost/notifications/entities/expense_request_notification.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/notifications/services/single_notification_reader.dart';

class ExpenserequestNotificationsListTile extends StatefulWidget {
  final ExpenseRequestNotification notification;
  ExpenserequestNotificationsListTile(this.notification);

  @override
  _ExpenserequestNotificationsListTileState createState() =>
      _ExpenserequestNotificationsListTileState();
}

class _ExpenserequestNotificationsListTileState
    extends State<ExpenserequestNotificationsListTile> {
  SingleNotificationReader _singleNotificationReader =
      SingleNotificationReader();
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
            style: widget.notification.isRead
                ? TextStyle(
                    color: AppColors.defaultColor,
                    fontWeight: FontWeight.normal)
                : TextStyle(
                    color: AppColors.defaultColor, fontWeight: FontWeight.bold),
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
                  text: _convertToDateFormat(widget.notification.createdAt),
                  style: TextStyle(color: Colors.grey, fontSize: 12))
            ]),
          )
        ],
      ),
      onTap: () => {
        widget.notification.isRead = true,
        _readSingleNotification(widget.notification)
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
