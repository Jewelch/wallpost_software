import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/notifications/entities/expense_request_notification.dart';
import 'package:wallpost/notifications/services/single_notification_reader.dart';

class ExpenseRequestNotificationsListTile extends StatefulWidget {
  final ExpenseRequestNotification notification;

  ExpenseRequestNotificationsListTile(this.notification);

  @override
  _ExpenseRequestNotificationsListTileState createState() => _ExpenseRequestNotificationsListTileState();
}

class _ExpenseRequestNotificationsListTileState extends State<ExpenseRequestNotificationsListTile> {
  SingleNotificationReader _singleNotificationReader = SingleNotificationReader();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 4),
        leading: Icon(Icons.account_circle_sharp, size: 36),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.notification.title,
              style: TextStyles.subTitleTextStyle.copyWith(
                  color: AppColors.defaultColor,
                  fontWeight: widget.notification.isRead ? FontWeight.normal : FontWeight.bold),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: SelectedCompanyProvider().getSelectedCompanyForCurrentUser().currency,
                    style: TextStyles.labelTextStyle.copyWith(color: AppColors.defaultColor),
                  ),
                  TextSpan(
                    text: ' ${widget.notification.amount}',
                    style: TextStyles.subTitleTextStyle
                        .copyWith(color: AppColors.defaultColor, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Requested By: ',
                        style: TextStyles.labelTextStyle.copyWith(color: Colors.black),
                      ),
                      TextSpan(
                        text: widget.notification.applicantName,
                        style: TextStyles.labelTextStyle,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_outlined, color: Colors.grey, size: 14)
              ],
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Date: ',
                    style: TextStyles.labelTextStyle.copyWith(color: Colors.black),
                  ),
                  TextSpan(text: _convertToDateFormat(widget.notification.createdAt), style: TextStyles.labelTextStyle)
                ],
              ),
            )
          ],
        ),
        onTap: () {
          widget.notification.isRead = true;
          _readSingleNotification(widget.notification);
        },
      ),
    );
  }

  String _convertToDateFormat(DateTime date) {
    var selectedCompany = SelectedCompanyProvider().getSelectedCompanyForCurrentUser();
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
