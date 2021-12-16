// @dart=2.9

import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/notifications/entities/notification.dart';

void main() {
  test('if routes are identified correctly', () async {
    var route = NotificationRoute('routeWithTheWord:task');
    expect(route.isATaskNotification(), true);

    route = NotificationRoute('routeWithTheWord:leave');
    expect(route.isALeaveNotification(), true);

    route = NotificationRoute('routeWithTheWord:handover');
    expect(route.isAHandoverNotification(), true);

    route = NotificationRoute('routeWithTheWord:expense');
    expect(route.isAnExpenseRequestNotification(), true);
  });
}
