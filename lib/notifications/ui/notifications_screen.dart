import 'dart:ui';
import 'package:flutter/material.dart';
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
      // _notificationList = [];
    });

    try {
      var notificationData = await _notificationsListProvider.getNext();
      setState(() {
        _notificationList.addAll(notificationData);

        print("notification daataaa,,," + notificationData.toString());
        isLoading = false;
      });
    } on WPException catch (_) {
      setState(() => showError = true);
    }
  }

  void _getUnreadNotificatiionsCount() async {
    try {
      var unraedNotifications =
          await _unreadNotificationsCountProvider.getCount();
      setState(() {
        _unreadNoticationsCount = unraedNotifications.totalUnreadNotifications;
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
                  _readAllNotification();
                },
                child: Text(
                  'Read all',
                  style: TextStyle(color: AppColors.defaultColor),
                ),
              )
            ]),
            SizedBox(height: 4),
            // Expanded(
            //     child: NotificationListener<ScrollNotification>(
            //   // ignore: missing_return
            //   onNotification: (ScrollNotification scrollinfo) {
            //     if (scrollinfo.metrics.pixels ==
            //         scrollinfo.metrics.maxScrollExtent) {
            //       _getNotificationList();
            //       setState(() {
            //         isLoading = true;
            //       });
            //     }
            //   },
            //   child: _buildNotificationListWidget(),
            // )),
            // Container(
            //   height: isLoading ? 50.0 : 0,
            //   color: Colors.transparent,
            //   child: Center(
            //     child: new CircularProgressIndicator(),
            //   ),
            // ),
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
              for (var i = 0; i < _notificationList.length; i++) {
                print("notificatlist..........????" +
                    _notificationList[i].toString());
                if (_notificationList[i].isATaskNotification) {
                  return TaskNotificationsListTile(_notificationList[i]);
                } else if (_notificationList[i].isALeaveNotification) {
                  return LeaveNotificationsListTile(_notificationList[i]);
                } else if (_notificationList[i].isAHandoverNotification) {
                  return HandoverNotificationsListTile(_notificationList[i]);
                } else {
                  return ExpenserequestNotificationsListTile(
                      _notificationList[i]);
                }
              }
              return null;
            }),
      );
    else {
      return showError ? _buildErrorAndRetryView() : _buildProgressIndicator();
    }
  }

  void _readAllNotification() async {
    setState(() {
      showError = false;
    });

    try {
      _allNotificationsReader.markAllAsRead();
      setState(() {
        // _getNotificationList();
        _getUnreadNotificatiionsCount();
      });
    } on WPException catch (_) {
      setState(() => showError = true);
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
