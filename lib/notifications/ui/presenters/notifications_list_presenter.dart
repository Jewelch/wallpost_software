import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/_list_view/error_list_tile.dart';
import 'package:wallpost/_common_widgets/_list_view/loader_list_tile.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/notifications/services/notifications_list_provider.dart';
import 'package:wallpost/notifications/ui/expense_request_notifications_list_tile.dart';
import 'package:wallpost/notifications/ui/handover_notifications_list_tile.dart';
import 'package:wallpost/notifications/ui/leave_notifications_list_tile.dart';
import 'package:wallpost/notifications/ui/task_notifications_list_tile.dart';

abstract class NotificationsListView {
  void reloadData();
}

class NotificationsListPresenter {
  final NotificationsListView view;
  final NotificationsListProvider provider;
  List notification = [];
  String _errorMessage;

  NotificationsListPresenter(this.view)
      : provider = NotificationsListProvider();

  NotificationsListPresenter.initWith(this.view, this.provider);

  Future<void> loadNextListOfNotifications() async {
    if (provider.isLoading || provider.didReachListEnd) return null;
    _resetErrors();
    try {
      var notificationsList = await provider.getNext();
      notification.addAll(notificationsList);
      view.reloadData();
    } on WPException catch (e) {
      _errorMessage = e.userReadableMessage;
      view.reloadData();
    }
  }

  int getNumberOfItems() {
    if (_hasErrors()) return notification.length + 1;

    if (notification.isEmpty) return 1;

    if (provider.didReachListEnd) {
      return notification.length;
    } else {
      return notification.length + 1;
    }
  }

  Widget getViewAtIndex(int index) {
    if (_shouldShowErrorAtIndex(index))
      return ErrorListTile('$_errorMessage\nTap here to reload.');

    if (notification.isEmpty) return _buildViewWhenThereAreNoResults();

    if (index < notification.length) {
      if (notification[index].isATaskNotification) {
        return TaskNotificationsListTile(notification[index]);
      } else if (notification[index].isALeaveNotification) {
        return LeaveNotificationsListTile(notification[index]);
      } else if (notification[index].isAHandoverNotification) {
        return HandoverNotificationsListTile(notification[index]);
      } else {
        return ExpenseRequestNotificationsListTile(notification[index]);
      }
    } else {
      return LoaderListTile();
    }
  }

  bool _shouldShowErrorAtIndex(int index) {
    return _hasErrors() && index == notification.length;
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
    notification.clear();
    view.reloadData();
  }

  void _resetErrors() {
    _errorMessage = null;
  }

  bool _hasErrors() {
    return _errorMessage != null;
  }
}
