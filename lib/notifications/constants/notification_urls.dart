import 'package:wallpost/_shared/constants/base_urls.dart';

class NotificationUrls {
  static String unreadNotificationsCountUrl() {
    return '${BaseUrls.baseUrlV2()}/notifications/count?';
  }
}
