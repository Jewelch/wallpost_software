import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/app_bars/wp_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';
import 'package:wallpost/notifications/services/all_notifications_reader.dart';
import 'package:wallpost/notifications/services/unread_notifications_count_provider.dart';
import 'package:wallpost/notifications/ui/presenters/notifications_list_presenter.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    implements NotificationsListView {
  UnreadNotificationsCountProvider _unreadNotificationsCountProvider =
      UnreadNotificationsCountProvider();
  AllNotificationsReader _allNotificationsReader = AllNotificationsReader();
  NotificationsListPresenter _presenter;
  ScrollController _scrollController;
  num _unreadNotificationsCount = 0;

  @override
  void initState() {
    _scrollController = ScrollController();
    _presenter = NotificationsListPresenter(this);
    _presenter.loadNextListOfNotifications();
    _setupScrollDownToLoadMoreItems();
    _getUnreadNotificationsCount();
    super.initState();
  }

  void _setupScrollDownToLoadMoreItems() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _presenter.loadNextListOfNotifications();
      }
    });
  }

  void _getUnreadNotificationsCount() async {
    try {
      var unreadNotificationsCount =
          await _unreadNotificationsCountProvider.getCount();
      setStateIfMounted(() {
        _unreadNotificationsCount =
            unreadNotificationsCount.totalUnreadNotifications;
      });
    } on WPException catch (_) {
      setStateIfMounted(() => {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WPAppBar(
        title:
            SelectedCompanyProvider().getSelectedCompanyForCurrentUser().name,
        leading: RoundedIconButton(
          iconName: 'assets/icons/back.svg',
          iconSize: 12,
          onPressed: () => Navigator.pushNamed(context, RouteNames.main),
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: RefreshIndicator(
        onRefresh: _getRefreshList,
        child: ListView.separated(
          controller: _scrollController,
          itemCount: _presenter.getNumberOfItems(),
          separatorBuilder: (context, i) => const Divider(),
          itemBuilder: (context, index) {
            return _presenter.getViewAtIndex(index);
          },
        ),
      ),
    );
  }

  Future<void> _getRefreshList() async {
    setState(() {
      _presenter.reset();
      _presenter.loadNextListOfNotifications();
    });
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
    try {
      await _allNotificationsReader.markAllAsRead();
      setStateIfMounted(() {
        _presenter.reset();
        _presenter.loadNextListOfNotifications();
        _getUnreadNotificationsCount();
      });
    } on WPException catch (error) {
      Alert.showSimpleAlert(
        context,
        title: 'Failed to read all notifications',
        message: error.userReadableMessage,
        buttonTitle: 'Okay',
      );
    }
  }

  void setStateIfMounted(VoidCallback callback) {
    if (this.mounted == false) return;
    setState(() => callback());
  }

  @override
  void reloadData() {
    if (this.mounted) setState(() {});
  }
}
