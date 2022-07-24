import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wallpost/firebase_fcm/exceptions/missing_firebase_device_token.dart';

class FireBaseDeviceTokenProvider {
  Future<String> getDeviceToken() async {
    var token = await FirebaseMessaging.instance.getToken();
    if (token == null) throw MissingFirebaseDeviceToken();
    return token;
  }
}
