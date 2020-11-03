import 'dart:async';

import 'package:wallpost/_shared/wpapi/wp_api.dart';
import 'package:wallpost/notifications/constants/notification_urls.dart';
import 'package:wallpost/notifications/entities/notification.dart';

class SingleNotificationReader {
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  String _sessionId;

  SingleNotificationReader.initWith(this._networkAdapter);

  SingleNotificationReader() : _networkAdapter = WPAPI();

  Future<void> markAsRead(Notification notification) async {
    var url = NotificationUrls.markSingleNotificationsAsReadUrl(notification.notificationId);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    isLoading = true;

    try {
      await _networkAdapter.post(apiRequest);
      isLoading = false;
      return null;
    } on APIException catch (exception) {
      isLoading = false;
      throw exception;
    }
  }
}
