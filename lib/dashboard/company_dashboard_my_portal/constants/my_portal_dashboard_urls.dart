import '../../../../_shared/constants/base_urls.dart';

class MyPortalDashboardUrls {
  static String ownerMyPortalDataUrl(String companyId, int? month, int year) {
    var url = '${BaseUrls.hrUrlV3()}/companies/$companyId/get_dashboard_data?';
    if (month != null) url += "month=$month&";
    url += "year=$year";
    return url;
  }

  static String employeeMyPortalDataUrl(String companyId) {
    return '${BaseUrls.hrUrlV3()}/companies/$companyId/get_dashboard_data';
  }
}
