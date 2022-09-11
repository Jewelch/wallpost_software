import 'package:wallpost/notification_center/entities/push_notification.dart';
import 'package:wallpost/notification_center/firebase/firebase_wrapper.dart';

class MockFirebaseWrapper extends FirebaseWrapper {
  String? tokenToReturn;
  Function(String)? didUpdateFirebaseTokenCallback;
  Function(PushNotification)? didOpenAppByTappingOnNotificationCallback;
  Function(PushNotification)? didReceiveNotificationInForegroundCallback;
  bool didCallGetToken = false;
  bool didCallAddFirebaseTokenUpdateListener = false;
  bool didCallAddNotificationListeners = false;
  bool didCallDeleteToken = false;

  void reset() {
    tokenToReturn = null;
    didUpdateFirebaseTokenCallback = null;
    didOpenAppByTappingOnNotificationCallback = null;
    didReceiveNotificationInForegroundCallback = null;
    didCallGetToken = false;
    didCallAddFirebaseTokenUpdateListener = false;
    didCallAddNotificationListeners = false;
    didCallDeleteToken = false;
  }

  @override
  Future<String?> getFirebaseToken() {
    didCallGetToken = true;
    return Future.value(tokenToReturn);
  }

  @override
  void addFirebaseTokenUpdateListener(Function(String) didUpdateFirebaseToken) {
    didCallAddFirebaseTokenUpdateListener = true;
    didUpdateFirebaseTokenCallback = didUpdateFirebaseToken;
  }

  @override
  void addNotificationListeners({
    required Function(PushNotification) didOpenAppByTappingOnNotification,
    required Function(PushNotification) didReceiveNotificationInForeground,
  }) {
    didCallAddNotificationListeners = true;
    didOpenAppByTappingOnNotificationCallback = didOpenAppByTappingOnNotification;
    didReceiveNotificationInForegroundCallback = didReceiveNotificationInForeground;
  }

  @override
  Future<void> deleteFirebaseToken() {
    didCallDeleteToken = true;
    return Future.value(null);
  }
}
