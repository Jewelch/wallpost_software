import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_break_down_wise_options.dart';

import '../../../../_shared/constants/base_urls.dart';

class RestaurantDashboardUrls {
  static String getSalesAmountsUrl(
    String companyId,
    DateRange dateRange,
  ) {
    var url = '${BaseUrls.restaurantUrlV2()}/companies/$companyId/store/0/consolidated_stats/sales_data/dashboard';
    url +=
        '?date_filter_type=date_between&start_date=${dateRange.startDate.yyyyMMddString()}&end_date=${dateRange.endDate.yyyyMMddString()}';
    return url;
  }

  static String getSalesBreakDownsUrl(
    String companyId,
    SalesBreakDownWiseOptions salesBreakDownWises,
    DateRange dateRange,
  ) {
    var url =
        '${BaseUrls.restaurantUrlV2()}/companies/$companyId/store/0/consolidated_stats/sales_breakdown/by/${salesBreakDownWises.toRawString()}/mobile';
    url +=
        '?date_filter_type=date_between&start_date=${dateRange.startDate.yyyyMMddString()}&end_date=${dateRange.endDate.yyyyMMddString()}';
    return url;
  }
}
