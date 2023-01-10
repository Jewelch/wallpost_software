import '../../../../_shared/constants/base_urls.dart';

class ManagerMyPortalDashboardUrls {
  static String managerMyPortalDataUrl(String companyId, int? month, int? year) {
    var url = '${BaseUrls.hrUrlV3()}/companies/$companyId/get_dashboard_data?';
    if (month != null) url += "month=$month";
    if (year != null) url += "&year=$year";
    return url;
  }

  static String crmDataUrl(String companyId, int? month, int? year) {
    var url = '${BaseUrls.miscUrlV2()}/crm/companies/$companyId/dashboard/consolidated_stats?';
    if (month != null) url += "month=$month";
    if (year != null) url += "&year=$year";
    return url;
  }

  static String financeDataUrl(String companyId, int? month, int? year) {
    var url = '${BaseUrls.hrUrlV3()}/companies/$companyId/mobile/finance_data';
    if (month != null) url += "month=$month";
    if (year != null) url += "&year=$year";
    return url;
  }

  static String hrDataUrl(String companyId, int? month, int? year) {
    var url = '${BaseUrls.hrUrlV3()}/companies/$companyId/dashboard/hr/consolidated_stats?';
    if (month != null) url += "month=$month";
    if (year != null) url += "&year=$year";
    return url;
  }

  static String restaurantDataUrl(String companyId, int? month, int? year) {
    var url =
        '${BaseUrls.restaurantUrlV2()}/companies/$companyId/store/0/consolidated_stats/sales_data?at_a_glance_sales_type=today';
    if (month != null) url += "&filtered_sales_month=$month";
    if (year != null) url += "&filtered_sales_year=$year";
    return url;
  }

  static String retailDataUrl(String companyId, int? month, int? year) {
    var url =
        '${BaseUrls.restaurantUrlV2()}/companies/$companyId/store/0/consolidated_stats/sales_data?at_a_glance_sales_type=today';
    if (month != null) url += "&filtered_sales_month=$month";
    if (year != null) url += "&filtered_sales_year=$year";
    return url;
  }
}
