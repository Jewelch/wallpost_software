import 'package:wallpost/_shared/constants/base_urls.dart';

class NotificationUrls {
  static String unreadNotificationsCountUrl() {
    return '${BaseUrls.baseUrlV2()}/notifications/count?';
  }

  static String notificationsListUrl(String companyId, String moduleId, String pageNumber, String itemsPerPage) {
    return '${BaseUrls.baseUrlV2()}/notifications/companies/$companyId/modules/$moduleId?&page=$pageNumber&per_page=$itemsPerPage';
  }
}
