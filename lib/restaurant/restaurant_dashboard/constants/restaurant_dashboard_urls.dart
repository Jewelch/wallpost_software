import 'package:wallpost/restaurant/restaurant_dashboard/entities/date_range_filters.dart';

import '../../../../_shared/constants/base_urls.dart';

class RestaurantDashboardUrls {
  static String getSalesAmountsUrl(
    String companyId,
    String? storeId,
    DateRangeFilters dateFilters,
  ) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/store/0/consolidated_stats/sales_data?store=0';
  }
}
