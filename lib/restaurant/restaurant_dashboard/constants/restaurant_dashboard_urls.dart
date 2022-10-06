import '../../../../_shared/constants/base_urls.dart';

class RestaurantDashboardUrls {
  static String getSalesAmountsUrl(
    String companyId,
    String? storeId,
  ) =>
      '${BaseUrls.hrUrlV2()}/companies/$companyId/store/0/consolidated_stats/sales_data?store=0';
}
