import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';

import '../../../../_shared/constants/base_urls.dart';

class RestaurantDashboardUrls {
  static String getSalesAmountsUrl(
    String companyId,
    String? storeId,
    DateRangeFilters dateFilters,
  ) {
    var url =
        '${BaseUrls.hrUrlV2()}/companies/$companyId/store/$storeId/consolidated_stats/sales_data?date_filter_type=${dateFilters.selectedRangeOption.toRawString()}';
    if (dateFilters.selectedRangeOption == SelectableDateRangeOptions.custom) {
      url += "&start_date=${dateFilters.startDate.yMMMd}";
      url += "&end_date=${dateFilters.endDate.yMMMd}";
    }
    return url;
  }
}
