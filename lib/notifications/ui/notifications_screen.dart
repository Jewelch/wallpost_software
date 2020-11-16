import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/app_bars/wp_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';
import 'package:wallpost/notifications/services/all_notifications_reader.dart';
import 'package:wallpost/notifications/services/unread_notifications_count_provider.dart';
import 'package:wallpost/notifications/ui/expense_request_notifications_list_tile.dart';
import 'package:wallpost/notifications/ui/handover_notifications_list_tile.dart';
import 'package:wallpost/notifications/ui/leave_notifications_list_tile.dart';
import 'package:wallpost/notifications/services/notifications_list_provider.dart';
import 'package:wallpost/notifications/ui/task_notifications_list_tile.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationsListProvider _notificationsListProvider =
      NotificationsListProvider();
  UnreadNotificationsCountProvider _unreadNotificationsCountProvider =
      UnreadNotificationsCountProvider();
  AllNotificationsReader _allNotificationsReader = AllNotificationsReader();

  List _notificationList = [];
  bool showError = false;
  bool isLoading = false;
  num _unreadNoticationsCount = 0;

  @override
  void initState() {
    super.initState();
    _getNotificationList();
    _getUnreadNotificatiionsCount();
  }

  void _getNotificationList() async {
    setState(() {
      showError = false;
    });

    try {
      var notificationData = await _notificationsListProvider.getNext();
      setState(() {
        _notificationList.addAll(notificationData);
        isLoading = false;
      });
    } on WPException catch (_) {
      setState(() => showError = true);
    }
  }

  void _getUnreadNotificatiionsCount() async {
    try {
      var unraedNotificationsCount =
          await _unreadNotificationsCountProvider.getCount();
      setState(() {
        _unreadNoticationsCount =
            unraedNotificationsCount.totalUnreadNotifications;
      });
    } on WPException catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WPAppBar(
        title:
            SelectedCompanyProvider().getSelectedCompanyForCurrentUser().name,
        leading: RoundedIconButton(
          iconName: 'assets/icons/back.svg',
          iconSize: 12,
          onPressed: () => {},
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                'Notifications ' + '($_unreadNoticationsCount)',
                style: TextStyle(fontSize: 16),
              ),
              GestureDetector(
                onTap: () {
                  _showReadAllConfirmationAlert();
                },
                child: Text(
                  'Read all',
                  style: TextStyle(color: AppColors.defaultColor),
                ),
              )
            ]),
            SizedBox(height: 4),
            Expanded(child: _buildNotificationListWidget())
          ]),
        ),
      ),
    );
  }

  Widget _buildNotificationListWidget() {
    if (_notificationList.length > 0)
      return Container(
        child: ListView.separated(
            itemCount: _notificationList.length,
            separatorBuilder: (context, i) => const Divider(),
            itemBuilder: (context, index) {
              if (_notificationList[index].isATaskNotification) {
                return TaskNotificationsListTile(_notificationList[index]);
              } else if (_notificationList[index].isALeaveNotification) {
                return LeaveNotificationsListTile(_notificationList[index]);
              } else if (_notificationList[index].isAHandoverNotification) {
                return HandoverNotificationsListTile(_notificationList[index]);
              } else {
                return ExpenserequestNotificationsListTile(
                    _notificationList[index]);
              }
            }),
      );
    else {
      return showError ? _buildErrorAndRetryView() : _buildProgressIndicator();
    }
  }

  void _showReadAllConfirmationAlert() {
    Alert.showSimpleAlertWithButtons(context,
        title: 'Read All Notification',
        message: 'Are you sure you want to read all?',
        buttonOneTitle: 'No',
        buttonTwoTitle: 'Yes',
        buttonTwoOnPressed: () => {_readAllNotification()});
  }

  void _readAllNotification() async {
    setState(() {
      _notificationList = [];
    });

    try {
      _allNotificationsReader.markAllAsRead();
      setState(() {
        _getNotificationList();
        _getUnreadNotificatiionsCount();
      });
    } on WPException catch (_) {
      setState(() => {});
    }
  }

  Widget _buildProgressIndicator() {
    return Center(
      child: Container(
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 30, height: 30, child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorAndRetryView() {
    return Container(
      height: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              child: Text(
                'Failed to performance\nTap Here To Retry',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              onPressed: () {
                setState(() {});
                _getNotificationList();
              },
            ),
          ],
        ),
      ),
    );
  }
}
