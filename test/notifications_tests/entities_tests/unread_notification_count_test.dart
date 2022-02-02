import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/notifications/entities/unread_notifications_count.dart';

import '../mocks.dart';

void main() {
  test('get unread notifications gets calculated', () {
    var unreadNotificationCount = UnreadNotificationsCount.fromJson(Mocks.unreadNotificationsCount);

    int count = unreadNotificationCount.getTotalUnreadNotificationCount();

    expect(count, 97);
  });
}
