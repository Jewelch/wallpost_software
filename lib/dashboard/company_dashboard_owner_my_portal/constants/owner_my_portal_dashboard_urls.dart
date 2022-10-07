import '../../../../_shared/constants/base_urls.dart';

class OwnerMyPortalDashboardUrls {
  static String ownerMyPortalDataUrl(String companyId, int? month, int? year) {
    var url = '${BaseUrls.hrUrlV3()}/companies/$companyId/get_dashboard_data?';
    if (month != null) url += "month=$month";
    if (year != null) url += "&year=$year";
    return url;
  }

  static String crmDataUrl(String companyId, int? month, int? year) {
    var url = '${BaseUrls.hrUrlV3()}/companies/$companyId/crm_data?';
    if (month != null) url += "month=$month";
    if (year != null) url += "&year=$year";
    return url;
  }

  static String hrDataUrl(String companyId, int? month, int? year) {
    var url = '${BaseUrls.hrUrlV3()}/companies/$companyId/hr_data?';
    if (month != null) url += "month=$month";
    if (year != null) url += "&year=$year";
    return url;
  }

  static String restaurantDataUrl(String companyId, int? month, int? year) {
    var url = '${BaseUrls.hrUrlV3()}/companies/$companyId/restaurant_data?';
    if (month != null) url += "month=$month";
    if (year != null) url += "&year=$year";
    return url;
  }

  static String retailDataUrl(String companyId, int? month, int? year) {
    var url = '${BaseUrls.hrUrlV3()}/companies/$companyId/retail_data?';
    if (month != null) url += "month=$month";
    if (year != null) url += "&year=$year";
    return url;
  }
}
