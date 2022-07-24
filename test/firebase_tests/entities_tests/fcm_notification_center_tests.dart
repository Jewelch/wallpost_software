import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/firebase_fcm/entities/fcm_notification.dart';
import 'package:wallpost/firebase_fcm/entities/fcm_notification_route.dart';
import 'package:wallpost/firebase_fcm/entities/fcm_notifications_center.dart';
import 'package:wallpost/firebase_fcm/observers/attendance_notification_observers.dart';
import 'package:wallpost/firebase_fcm/observers/expense_notification_observers.dart';
import 'package:wallpost/firebase_fcm/observers/leave_notification_observers.dart';

class MockFcmNotification extends Mock implements FcmNotification {}

class MockExpenseNotificationListener extends Mock implements ExpenseNotificationObserver {}

class MockLeaveNotificationListener extends Mock implements LeaveNotificationObserver {}

class MockAttendanceNotificationListener extends Mock implements AttendanceNotificationObserver {}

main() {
  var notificationCenter = FcmNotificationCenter();
  var fcmNotification = MockFcmNotification();

  test('notify expense notification listeners when receiving expense notification', () {
    when(() => fcmNotification.route).thenReturn(FcmNotificationRoute.expenseRequest);
    var listener1 = MockExpenseNotificationListener();
    var listener2 = MockExpenseNotificationListener();

    notificationCenter.addExpenseNotificationListener(listener1);
    notificationCenter.addExpenseNotificationListener(listener2);
    notificationCenter.processNotification(fcmNotification);

    verifyInOrder([
      listener1.onExpenseNotificationReceived,
      listener2.onExpenseNotificationReceived,
    ]);
  });

  test('notify leave notification listeners when receiving leave notification', () {
    when(() => fcmNotification.route).thenReturn(FcmNotificationRoute.leaveRequest);
    var listener1 = MockLeaveNotificationListener();
    var listener2 = MockLeaveNotificationListener();

    notificationCenter.addLeaveNotificationListener(listener1);
    notificationCenter.addLeaveNotificationListener(listener2);
    notificationCenter.processNotification(fcmNotification);

    verifyInOrder([
      listener1.onLeaveNotificationReceived,
      listener2.onLeaveNotificationReceived,
    ]);
  });

  test('notify attendance notification listeners when receiving attendance notification', () {
    when(() => fcmNotification.route).thenReturn(FcmNotificationRoute.attendanceAdjustment);
    var listener1 = MockAttendanceNotificationListener();
    var listener2 = MockAttendanceNotificationListener();

    notificationCenter.addAttendanceNotificationListener(listener1);
    notificationCenter.addAttendanceNotificationListener(listener2);
    notificationCenter.processNotification(fcmNotification);

    verifyInOrder([
      listener1.onAttendanceNotificationReceived,
      listener2.onAttendanceNotificationReceived,
    ]);
  });

  test('remove expense notification listeners successfully', () {
    when(() => fcmNotification.route).thenReturn(FcmNotificationRoute.expenseRequest);
    var listener1 = MockExpenseNotificationListener();
    var listener2 = MockExpenseNotificationListener();

    notificationCenter.addExpenseNotificationListener(listener1);
    notificationCenter.addExpenseNotificationListener(listener2);
    notificationCenter.removeExpenseNotificationListener(listener2);
    notificationCenter.processNotification(fcmNotification);

    verify(listener1.onExpenseNotificationReceived);
    verifyZeroInteractions(listener2);
  });

  test('remove leave notification listeners successfully', () {
    when(() => fcmNotification.route).thenReturn(FcmNotificationRoute.leaveRequest);
    var listener1 = MockLeaveNotificationListener();
    var listener2 = MockLeaveNotificationListener();

    notificationCenter.addLeaveNotificationListener(listener1);
    notificationCenter.addLeaveNotificationListener(listener2);
    notificationCenter.removeLeaveNotificationListener(listener2);
    notificationCenter.processNotification(fcmNotification);

    verify(listener1.onLeaveNotificationReceived);
    verifyZeroInteractions(listener2);
  });

  test('remove attendance notification listeners successfully', () {
    when(() => fcmNotification.route).thenReturn(FcmNotificationRoute.attendanceAdjustment);
    var listener1 = MockAttendanceNotificationListener();
    var listener2 = MockAttendanceNotificationListener();

    notificationCenter.addAttendanceNotificationListener(listener1);
    notificationCenter.addAttendanceNotificationListener(listener2);
    notificationCenter.removeAttendanceNotificationListener(listener2);
    notificationCenter.processNotification(fcmNotification);

    verify(listener1.onAttendanceNotificationReceived);
    verifyZeroInteractions(listener2);
  });
}
