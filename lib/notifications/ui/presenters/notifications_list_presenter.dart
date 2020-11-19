import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/_list_view/error_list_tile.dart';
import 'package:wallpost/_common_widgets/_list_view/loader_list_tile.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/notifications/services/notifications_list_provider.dart';
import 'package:wallpost/notifications/ui/views/expense_request_notifications_list_tile.dart';
import 'package:wallpost/notifications/ui/views/handover_notifications_list_tile.dart';
import 'package:wallpost/notifications/ui/views/leave_notifications_list_tile.dart';
import 'package:wallpost/notifications/ui/views/task_notifications_list_tile.dart';

abstract class NotificationsListView {
  void reloadData();
}

class NotificationsListPresenter {
  final NotificationsListView view;
  final NotificationsListProvider provider;
  List notifications = [];
  String _errorMessage;

  NotificationsListPresenter(this.view)
      : provider = NotificationsListProvider();

  NotificationsListPresenter.initWith(this.view, this.provider);

  Future<void> loadNextListOfNotifications() async {
    if (provider.isLoading || provider.didReachListEnd) return null;
    _resetErrors();
    try {
      var notificationsList = await provider.getNext();
      notifications.addAll(notificationsList);
      view.reloadData();
    } on WPException catch (e) {
      _errorMessage = e.userReadableMessage;
      view.reloadData();
    }
  }

  int getNumberOfItems() {
    if (_hasErrors()) return notifications.length + 1;

    if (notifications.isEmpty) return 1;

    if (provider.didReachListEnd) {
      return notifications.length;
    } else {
      return notifications.length + 1;
    }
  }

  Widget getViewAtIndex(int index) {
    if (_shouldShowErrorAtIndex(index))
      return ErrorListTile('$_errorMessage\nTap here to reload.');

    if (notifications.isEmpty) return _buildViewWhenThereAreNoResults();

    if (index < notifications.length) {
      if (notifications[index].isATaskNotification) {
        return TaskNotificationsListTile(notifications[index]);
      } else if (notifications[index].isALeaveNotification) {
        return LeaveNotificationsListTile(notifications[index]);
      } else if (notifications[index].isAHandoverNotification) {
        return HandoverNotificationsListTile(notifications[index]);
      } else {
        return ExpenseRequestNotificationsListTile(notifications[index]);
      }
    } else {
      return LoaderListTile();
    }
  }

  bool _shouldShowErrorAtIndex(int index) {
    return _hasErrors() && index == notifications.length;
  }

  Widget _buildViewWhenThereAreNoResults() {
    if (provider.didReachListEnd) {
      return ErrorListTile(
          'There are no notifications to show.\n Tap here to reload.');
    } else {
      return LoaderListTile();
    }
  }

  //MARK: Util functions

  void reset() {
    provider.reset();
    _resetErrors();
    notifications.clear();
    view.reloadData();
  }

  void _resetErrors() {
    _errorMessage = null;
  }

  bool _hasErrors() {
    return _errorMessage != null;
  }
}
