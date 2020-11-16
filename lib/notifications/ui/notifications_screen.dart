import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/app_bars/wp_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';
import 'package:wallpost/notifications/services/all_notifications_reader.dart';
import 'package:wallpost/notifications/services/notifications_list_provider.dart';
import 'package:wallpost/notifications/services/unread_notifications_count_provider.dart';
import 'package:wallpost/notifications/ui/expense_request_notifications_list_tile.dart';
import 'package:wallpost/notifications/ui/handover_notifications_list_tile.dart';
import 'package:wallpost/notifications/ui/leave_notifications_list_tile.dart';
import 'package:wallpost/notifications/ui/task_notifications_list_tile.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationsListProvider _notificationsListProvider = NotificationsListProvider();
  UnreadNotificationsCountProvider _unreadNotificationsCountProvider = UnreadNotificationsCountProvider();
  AllNotificationsReader _allNotificationsReader = AllNotificationsReader();

  List _notificationList = [];
  bool showError = false;
  bool isLoading = false;
  num _unreadNotificationsCount = 0;

  @override
  void initState() {
    _getNotificationList();
    _getUnreadNotificationsCount();
    super.initState();
  }

  void _getNotificationList() async {
    setStateIfMounted(() => showError = false);

    try {
      var notificationData = await _notificationsListProvider.getNext();
      setStateIfMounted(() {
        _notificationList.addAll(notificationData);
        isLoading = false;
      });
    } on WPException catch (_) {
      setStateIfMounted(() => showError = true);
    }
  }

  void _getUnreadNotificationsCount() async {
    try {
      var unreadNotificationsCount = await _unreadNotificationsCountProvider.getCount();
      setStateIfMounted(() {
        _unreadNotificationsCount = unreadNotificationsCount.totalUnreadNotifications;
      });
    } on WPException catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WPAppBar(
        title: SelectedCompanyProvider().getSelectedCompanyForCurrentUser().name,
        leading: RoundedIconButton(
          iconName: 'assets/icons/back.svg',
          iconSize: 12,
          onPressed: () => {},
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Notifications ' + '($_unreadNotificationsCount)',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 50,
                    child: FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => _showReadAllConfirmationAlert(),
                      child: Text(
                        'Read All',
                        style: TextStyle(color: AppColors.defaultColor),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                ],
              ),
              SizedBox(width: 8),
              Divider(height: 1),
              Expanded(child: _buildNotificationListWidget())
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationListWidget() {
    if (_notificationList.length > 0)
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
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
                return ExpenseRequestNotificationsListTile(_notificationList[index]);
              }
            }),
      );
    else {
      return showError ? _buildErrorAndRetryView() : _buildProgressIndicator();
    }
  }

  void _showReadAllConfirmationAlert() {
    Alert.showSimpleAlertWithButtons(context,
        title: 'Read All Notifications',
        message: 'Are you sure you want to mark all notifications as read?',
        buttonOneTitle: 'No',
        buttonTwoTitle: 'Yes',
        buttonTwoOnPressed: () => {_readAllNotification()});
  }

  void _readAllNotification() async {
    setStateIfMounted(() => _notificationList = []);

    try {
      await _allNotificationsReader.markAllAsRead();
      setStateIfMounted(() {
        _getNotificationList();
        _getUnreadNotificationsCount();
      });
    } on WPException catch (_) {
      setStateIfMounted(() => {});
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
                setStateIfMounted(() {});
                _getNotificationList();
              },
            ),
          ],
        ),
      ),
    );
  }

  void setStateIfMounted(VoidCallback callback) {
    if (this.mounted == false) return;

    setState(() => callback());
  }
}

//TODO:
/*
1. Add pull down to refresh

2. Add scroll down to load more

3. Show error.
   Case 1 - When loading fails when there is nothing in the list.
   Case 2 - When loading fails when trying to load more items.

4. Copy spacing and styles from expense request approval tile to all other tiles
 */
