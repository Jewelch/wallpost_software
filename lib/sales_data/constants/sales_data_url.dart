import '../../../_shared/constants/base_urls.dart';

class SalesDataUrls {
  static String getSalesAmountsUrl(String companyId, String? storeId) {
    var url = '${BaseUrls.hrUrlV2()}/companies/$companyId/consolidated/stats/sales_data';
    if (storeId != null && storeId.isNotEmpty) url += "?storeId=$storeId";
    return url;
  }
}
