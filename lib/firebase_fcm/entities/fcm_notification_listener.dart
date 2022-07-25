import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wallpost/firebase_fcm/entities/fcm_notification.dart';

class FcmNotificationListener {
  static listen() {
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message received");
      var notification = FcmNotification.fromJson(event.data);
      print(event.notification!.body);
      print(event.data);
      print(event);
    });
  }
}
