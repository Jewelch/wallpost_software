import 'package:wallpost/_shared/constants/base_urls.dart';

class NotificationUrls {
  static String unreadNotificationsCountUrl() {
    return '${BaseUrls.baseUrlV2()}/notifications/count?';
  }

  static String notificationsListUrl(
      String companyId, int pageNumber, int itemsPerPage) {
    return '${BaseUrls.baseUrlV2()}/notifications/companies/$companyId/modules/1?&page=$pageNumber&per_page=$itemsPerPage';
  }

  static String markAllNotificationsAsReadUrl(String companyId) {
    return '${BaseUrls.baseUrlV2()}/company/$companyId/notifications/markasread?';
  }

  static String markSingleNotificationsAsReadUrl(String notificationId) {
    return '${BaseUrls.baseUrlV2()}/notifications/$notificationId?';
  }
}
