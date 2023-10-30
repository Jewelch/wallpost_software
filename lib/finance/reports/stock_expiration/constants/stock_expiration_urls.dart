import '../../../../../_shared/constants/base_urls.dart';

class StocksExpirationUrls {
  static String getExpiredUrl(String companyId,  int currentPage, int perPage) {
    var url =
        '${BaseUrls.financeUrlV2()}/companies/$companyId/reports/stock-expiry?consumedByMobile=true&page=$currentPage&perPage=$perPage&expired=true';
    return url;
  }

  static String getExpiredInDaysUrl(String companyId, int days, int currentPage, int perPage) {
    var url =
        '${BaseUrls.financeUrlV2()}/companies/$companyId/reports/stock-expiry?consumedByMobile=true&expired=false&days=$days&page=$currentPage&perPage=$perPage';
    return url;
  }
}
