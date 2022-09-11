import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/notification_center/firebase/firebase_wrapper.dart';
import 'package:wallpost/notification_center/services/notification_count_updater.dart';

import '../../main.dart';
import 'entities/push_notification.dart';
import 'notification_observer.dart';
import 'notification_router.dart';
import 'services/notification_token_synchronizer.dart';

class NotificationCenter {
  static NotificationCenter? _singleton;

  final CurrentUserProvider _userProvider;
  final FirebaseWrapper _firebaseWrapper;
  final NotificationTokenSynchronizer _notificationTokenSynchronizer;
  final NotificationCountUpdater _notificationCountUpdater;
  final NotificationRouter _notificationRouter;

  List<NotificationObserver> _expenseApprovalRequiredObservers = [];
  List<NotificationObserver> _expenseApprovedObservers = [];
  List<NotificationObserver> _expenseRejectedObservers = [];
  List<NotificationObserver> _leaveApprovalRequiredObservers = [];
  List<NotificationObserver> _leaveApprovedObservers = [];
  List<NotificationObserver> _leaveRejectedObservers = [];
  List<NotificationObserver> _attendanceAdjustmentApprovalRequiredObservers = [];
  List<NotificationObserver> _attendanceAdjustmentApprovedObservers = [];
  List<NotificationObserver> _attendanceAdjustmentRejectedObservers = [];

  NotificationCenter._(NotificationRouter router)
      : _userProvider = CurrentUserProvider(),
        _firebaseWrapper = FirebaseWrapper(),
        _notificationTokenSynchronizer = NotificationTokenSynchronizer(),
        _notificationCountUpdater = NotificationCountUpdater(),
        _notificationRouter = router;

  NotificationCenter.initWith(
    this._userProvider,
    this._firebaseWrapper,
    this._notificationTokenSynchronizer,
    this._notificationCountUpdater,
    this._notificationRouter,
  );

  static NotificationCenter getInstance() => _singleton!;

  ///
  /// Initialize firebase, this singleton class, and then
  ///
  /// If the user is logged in
  /// 1. sync the firebase token
  /// 2. add listeners for push notification
  ///
  /// If the user is logged out
  /// 1. remove push notification listeners
  ///
  static Future<void> initialize(NotificationRouter router) async {
    _singleton = NotificationCenter._(router);
    await _singleton!._firebaseWrapper.initialize();
  }

  Future<void> setupAndHandlePushNotifications() async {
    if (_userProvider.isLoggedIn()) {
      await _syncToken();
      await _startListeningToPushNotifications();
    } else {
      await _firebaseWrapper.deleteFirebaseToken();
    }
  }

  //MARK: Functions to sync the token

  Future<void> _syncToken() async {
    //get token and send to backend if the user is logged in
    String? token = await _firebaseWrapper.getFirebaseToken();
    if (token != null) _sync(token);

    //listen for token updates and send to backend if the user is logged in
    _firebaseWrapper.addFirebaseTokenUpdateListener(_sync);
  }

  void _sync(String token) {
    try {
      _notificationTokenSynchronizer.syncToken(token);
    } catch (e) {
      //do nothing
    }
  }

  //MARK: Functions to start listening to push notifications

  Future<void> _startListeningToPushNotifications() async {
    _firebaseWrapper.addNotificationListeners(
      didOpenAppByTappingOnNotification: _handleBackgroundPushNotification,
      didReceiveNotificationInForeground: _handleForegroundPushNotification,
    );
  }

  void _handleBackgroundPushNotification(PushNotification notification) {
    _goToScreen(notification);
  }

  void _handleForegroundPushNotification(PushNotification notification) {
    _showSnackBar(notification);
    _notifyListeners(notification);
  }

  void _showSnackBar(PushNotification notification) {
    final snackBar = SnackBar(
      content: Text(notification.title, style: TextStyle(color: Colors.white)),
      action: SnackBarAction(
        label: 'View',
        textColor: Colors.white,
        onPressed: () => _goToScreen(notification),
      ),
      duration: Duration(seconds: 6),
      backgroundColor: AppColors.defaultColorDark,
    );
    snackbarKey.currentState?.showSnackBar(snackBar);
  }

  void _goToScreen(PushNotification notification) {
    if (notification.isExpenseApprovalRequiredNotification()) {
      _notificationRouter.goToExpenseDetailScreenForApproval(
        notification.companyId,
        notification.objectId,
      );
    } else if (notification.isExpenseApprovedNotification() || notification.isExpenseRejectedNotification()) {
      _notificationRouter.goToExpenseDetailScreen(
        notification.companyId,
        notification.objectId,
      );
    } else if (notification.isLeaveApprovalRequiredNotification()) {
      _notificationRouter.goToLeaveDetailScreenForApproval(
        notification.companyId,
        notification.objectId,
      );
    } else if (notification.isLeaveApprovedNotification() || notification.isLeaveRejectedNotification()) {
      _notificationRouter.goToLeaveDetailScreen(
        notification.companyId,
        notification.objectId,
      );
    } else if (notification.isAttendanceAdjustmentApprovalRequiredNotification()) {
      _notificationRouter.goToAttendanceAdjustmentDetailScreenForApproval(
        notification.companyId,
        notification.objectId,
      );
    } else if (notification.isAttendanceAdjustmentApprovedNotification() ||
        notification.isAttendanceAdjustmentRejectedNotification()) {
      _notificationRouter.goToAttendanceAdjustmentDetailScreen(
        notification.companyId,
        notification.objectId,
      );
    }
  }

  void _notifyListeners(PushNotification notification) {
    if (notification.isExpenseApprovalRequiredNotification()) {
      _notifyAllListenersInList(
        _expenseApprovalRequiredObservers,
        notification,
      );
    } else if (notification.isExpenseApprovedNotification() || notification.isExpenseRejectedNotification()) {
      _notifyAllListenersInList(
        _expenseApprovedObservers,
        notification,
      );
      _notifyAllListenersInList(
        _expenseRejectedObservers,
        notification,
      );
    } else if (notification.isLeaveApprovalRequiredNotification()) {
      _notifyAllListenersInList(
        _leaveApprovalRequiredObservers,
        notification,
      );
    } else if (notification.isLeaveApprovedNotification() || notification.isLeaveRejectedNotification()) {
      _notifyAllListenersInList(
        _leaveApprovedObservers,
        notification,
      );
      _notifyAllListenersInList(
        _leaveRejectedObservers,
        notification,
      );
    } else if (notification.isAttendanceAdjustmentApprovalRequiredNotification()) {
      _notifyAllListenersInList(
        _attendanceAdjustmentApprovalRequiredObservers,
        notification,
      );
    } else if (notification.isAttendanceAdjustmentApprovedNotification() ||
        notification.isAttendanceAdjustmentRejectedNotification()) {
      _notifyAllListenersInList(
        _attendanceAdjustmentApprovedObservers,
        notification,
      );
      _notifyAllListenersInList(
        _attendanceAdjustmentRejectedObservers,
        notification,
      );
    }
  }

  void _notifyAllListenersInList(List<NotificationObserver> observers, PushNotification notification) {
    observers.forEach((observer) => observer.callback.call(notification));
  }

  //MARK: Functions to update notification app badge count

  Future<void> updateCount() async {
    try {
      await _notificationCountUpdater.updateCount();
    } catch (e) {
      //do nothing
    }
  }

  //MARK: Functions to add and remove observers

  void addExpenseApprovalRequiredObserver(NotificationObserver observer) {
    _expenseApprovalRequiredObservers.add(observer);
  }

  void addExpenseApprovedObserver(NotificationObserver observer) {
    _expenseApprovedObservers.add(observer);
  }

  void addExpenseRejectedObserver(NotificationObserver observer) {
    _expenseRejectedObservers.add(observer);
  }

  void addLeaveApprovalRequiredObserver(NotificationObserver observer) {
    _leaveApprovalRequiredObservers.add(observer);
  }

  void addLeaveApprovedObserver(NotificationObserver observer) {
    _leaveApprovedObservers.add(observer);
  }

  void addLeaveRejectedObserver(NotificationObserver observer) {
    _leaveRejectedObservers.add(observer);
  }

  void addAttendanceAdjustmentApprovalRequiredObserver(NotificationObserver observer) {
    _attendanceAdjustmentApprovalRequiredObservers.add(observer);
  }

  void addAttendanceAdjustmentApprovedObserver(NotificationObserver observer) {
    _attendanceAdjustmentApprovedObservers.add(observer);
  }

  void addAttendanceAdjustmentRejectedObserver(NotificationObserver observer) {
    _attendanceAdjustmentRejectedObservers.add(observer);
  }

  void removeObserverFromAllChannels({required String key}) {
    _expenseApprovalRequiredObservers.removeWhere((observer) => observer.key == key);
    _expenseApprovedObservers.removeWhere((observer) => observer.key == key);
    _expenseRejectedObservers.removeWhere((observer) => observer.key == key);
    _leaveApprovalRequiredObservers.removeWhere((observer) => observer.key == key);
    _leaveApprovedObservers.removeWhere((observer) => observer.key == key);
    _leaveRejectedObservers.removeWhere((observer) => observer.key == key);
    _attendanceAdjustmentApprovalRequiredObservers.removeWhere((observer) => observer.key == key);
    _attendanceAdjustmentApprovedObservers.removeWhere((observer) => observer.key == key);
    _attendanceAdjustmentRejectedObservers.removeWhere((observer) => observer.key == key);
  }
}
