import '../../../../_shared/constants/base_urls.dart';
import '../../../_shared/date_range_selector/date_range_filters.dart';
import '../../../_shared/extensions/date_extensions.dart';
import '../entities/sales_break_down_wise_options.dart';
import '../ui/views/screens/dashboard_screen.dart';

class DashboardUrls {
  static String getSalesAmountsUrl(
    String companyId,
    DateRangeFilters dateFilters,
    DashboardContext dashboardContext,
  ) {
    var url =
        '${BaseUrls.restaurantUrlV2()}/companies/$companyId/store/0/consolidated_stats/sales_data/dashboard?date_filter_type=${dateFilters.selectedRangeOption.toRawString()}';
    if (dateFilters.selectedRangeOption == SelectableDateRangeOptions.custom ||
        dateFilters.selectedRangeOption == SelectableDateRangeOptions.thisMonth) {
      url += "&start_date=${dateFilters.startDate.yyyyMMddString()}";
      url += "&end_date=${dateFilters.endDate.yyyyMMddString()}";
    }
    if (dashboardContext == DashboardContext.retail) url += "&forRetail=true";

    return url;
  }

  static String getSalesBreakDownsUrl(
    String companyId,
    SalesBreakDownWiseOptions salesBreakDownWises,
    DateRangeFilters dateFilters,
    DashboardContext dashboardContext,
  ) {
    var url =
        '${BaseUrls.restaurantUrlV2()}/companies/$companyId/store/0/consolidated_stats/sales_breakdown/by/${salesBreakDownWises.toRawString()}/mobile?date_filter_type=${dateFilters.selectedRangeOption.toRawString()}';
    if (dateFilters.selectedRangeOption == SelectableDateRangeOptions.custom ||
        dateFilters.selectedRangeOption == SelectableDateRangeOptions.thisMonth) {
      url += "&start_date=${dateFilters.startDate.yyyyMMddString()}";
      url += "&end_date=${dateFilters.endDate.yyyyMMddString()}";
    }
    if (dashboardContext == DashboardContext.retail) url += "&forRetail=true";

    return url;
  }
}
