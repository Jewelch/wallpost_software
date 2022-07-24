import 'package:wallpost/firebase_fcm/entities/fcm_notification.dart';
import 'package:wallpost/firebase_fcm/entities/fcm_notification_route.dart';
import 'package:wallpost/firebase_fcm/observers/attendance_notification_observers.dart';
import 'package:wallpost/firebase_fcm/observers/expense_notification_observers.dart';
import 'package:wallpost/firebase_fcm/observers/leave_notification_observers.dart';

class FcmNotificationCenter {
  // MARK: Singleton

  static FcmNotificationCenter _notificationCenter = FcmNotificationCenter._();

  FcmNotificationCenter._();

  factory FcmNotificationCenter() {
    return _notificationCenter;
  }

  // MARK: Observers

  final _expenseNotificationsObservers = <ExpenseNotificationObserver>[];
  final _leaveNotificationsObservers = <LeaveNotificationObserver>[];
  final _attendanceNotificationsObservers = <AttendanceNotificationObserver>[];

  void addExpenseNotificationListener(ExpenseNotificationObserver expenseObserver) {
    _expenseNotificationsObservers.add(expenseObserver);
  }

  void addLeaveNotificationListener(LeaveNotificationObserver leaveObserver) {
    _leaveNotificationsObservers.add(leaveObserver);
  }

  void addAttendanceNotificationListener(AttendanceNotificationObserver attendanceObserver) {
    _attendanceNotificationsObservers.add(attendanceObserver);
  }

  void removeExpenseNotificationListener(ExpenseNotificationObserver expenseObserver) {
    _expenseNotificationsObservers.remove(expenseObserver);
  }

  void removeLeaveNotificationListener(LeaveNotificationObserver leaveObserver) {
    _leaveNotificationsObservers.remove(leaveObserver);
  }

  void removeAttendanceNotificationListener(AttendanceNotificationObserver attendanceObserver) {
    _attendanceNotificationsObservers.remove(attendanceObserver);
  }

  //MARK: process coming fcm messages

  void processNotification(FcmNotification notification) {
    switch (notification.route) {
      case FcmNotificationRoute.expenseRequest:
        _notifyExpenseNotificationListeners();
        break;
      case FcmNotificationRoute.leaveRequest:
        _notifyLeaveNotificationListeners();
        break;
      case FcmNotificationRoute.attendanceAdjustment:
        _notifyAttendanceNotificationListeners();
        break;
    }
  }

  void _notifyExpenseNotificationListeners() {
    _expenseNotificationsObservers.forEach((listener) {
      listener.onExpenseNotificationReceived();
    });
  }

  void _notifyLeaveNotificationListeners() {
    _leaveNotificationsObservers.forEach((listener) {
      listener.onLeaveNotificationReceived();
    });
  }

  void _notifyAttendanceNotificationListeners() {
    _attendanceNotificationsObservers.forEach((listener) {
      listener.onAttendanceNotificationReceived();
    });
  }
}
