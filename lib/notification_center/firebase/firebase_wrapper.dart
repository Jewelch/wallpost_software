import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:wallpost/notification_center/entities/push_notification.dart';

class FirebaseWrapper {
  Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  Future<String?> getFirebaseToken() async {
    return FirebaseMessaging.instance.getToken();
  }

  void addFirebaseTokenUpdateListener(Function(String) didUpdateFirebaseToken) {
    FirebaseMessaging.instance.onTokenRefresh.listen(didUpdateFirebaseToken);
  }

  void addNotificationListeners({
    required Function(PushNotification) didOpenAppByTappingOnNotification,
    required Function(PushNotification) didReceiveNotificationInForeground,
  }) async {
    //getting messages which caused the application to open from a terminated state
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      var notification = _initPushNotification(initialMessage);
      if (notification != null) didOpenAppByTappingOnNotification(notification);
    }

    //listening to messages which caused the application to open from background
    FirebaseMessaging.onMessageOpenedApp.listen((backgroundMessage) {
      var notification = _initPushNotification(backgroundMessage);
      if (notification != null) didOpenAppByTappingOnNotification(notification);
    });

    //handle foreground notification
    FirebaseMessaging.onMessage.listen((foregroundMessage) {
      var notification = _initPushNotification(foregroundMessage);
      if (notification != null) didReceiveNotificationInForeground(notification);
    });
  }

  PushNotification? _initPushNotification(RemoteMessage message) {
    debugPrint("--------------------------------------------------------------------");
    debugPrint("INITIALIZING PUSH NOTIFICATION\n${message.toMap()}");
    debugPrint("--------------------------------------------------------------------");
    try {
      return PushNotification.fromJson(message.data);
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteFirebaseToken() async {
    //removes access to an FCM token previously authorized.
    //messages sent by the server to the deleted token will fail.
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      //do nothing
    }
  }
}
