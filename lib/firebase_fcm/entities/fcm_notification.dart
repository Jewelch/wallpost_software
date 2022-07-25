import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/firebase_fcm/entities/fcm_notification_route.dart';

class FcmNotification extends JSONInitializable {
  late final FcmNotificationRoute route;
  late final Map<String, dynamic> data;

  FcmNotification.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap);
}
