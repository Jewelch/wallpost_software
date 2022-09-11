import 'package:wallpost/_shared/constants/base_urls.dart';

class NotificationUrls {
  static String syncTokenUrl() {
    return '${BaseUrls.baseUrlV2()}/device/token';
  }

  static String notificationCountUrl() {
    return '${BaseUrls.hrUrlV3()}/groupdashboard';
  }
}
