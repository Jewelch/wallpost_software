import 'package:wallpost/notification_center/entities/push_notification.dart';

class NotificationObserver {
  final String key;
  final Function(PushNotification) callback;

  NotificationObserver({required this.key, required this.callback});
}
