import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_break_down_wise_options.dart';

import '../../../../_shared/constants/base_urls.dart';

class RestaurantDashboardUrls {
  static String getSalesAmountsUrl(
    String companyId,
    DateRangeFilters dateFilters,
  ) {
    var url =
        '${BaseUrls.restaurantUrlV2()}/companies/$companyId/store/0/consolidated_stats/sales_data?date_filter_type=${dateFilters.selectedRangeOption.toRawString()}';
    if (dateFilters.selectedRangeOption == SelectableDateRangeOptions.custom) {
      url += "&start_date=${dateFilters.startDate.yyyyMMddString()}";
      url += "&end_date=${dateFilters.endDate.yyyyMMddString()}";
    }
    return url;
  }

  static String getSalesBreakDownsUrl(
    String companyId,
    SalesBreakDownWiseOptions salesBreakDownWises,
    DateRangeFilters dateFilters,
  ) {
    var url =
        '${BaseUrls.restaurantUrlV2()}/companies/$companyId/store/0/consolidated_stats/sales_breakdown/by/${salesBreakDownWises.toRawString()}?date_filter_type=${dateFilters.selectedRangeOption.toRawString()}';
    if (dateFilters.selectedRangeOption == SelectableDateRangeOptions.custom) {
      url += "&start_date=${dateFilters.startDate.yyyyMMddString()}";
      url += "&end_date=${dateFilters.endDate.yyyyMMddString()}";
    }
    return url;
  }
}
