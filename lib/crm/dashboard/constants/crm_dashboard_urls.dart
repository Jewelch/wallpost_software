import '../../../../_shared/constants/base_urls.dart';

class CrmDashboardUrls {
  static String getDashboardDataUrl(String companyId, int month, int year) {
    var url = '${BaseUrls.miscUrlV2()}/crm/companies/$companyId/dashboard/mobile_inner_page?package=ADVISORY';
    url += month == 0 ? "&month=YTD" : "&month=$month";
    url += "&year=$year";
    return url;
  }
}
