import '../../../../_shared/date_range_selector/date_range_filters.dart';
import 'hourly_sales_report_sort_options.dart';

class HourlySalesReportFilters {
  DateRangeFilters dateRangeFilters = DateRangeFilters();
  HourlySalesReportSortOptions sortOptions = HourlySalesReportSortOptions.byRevenueLowToHigh;

  HourlySalesReportFilters copy() {
    var itemSalesFilters = HourlySalesReportFilters();
    itemSalesFilters.dateRangeFilters = dateRangeFilters.copy();
    itemSalesFilters.sortOptions = sortOptions;
    return itemSalesFilters;
  }

  List<String> toReadableListOfString() {
    return [dateRangeFilters.toReadableString(), sortOptions.toReadableString()];
  }

  void reset() {
    dateRangeFilters = DateRangeFilters();
    sortOptions = HourlySalesReportSortOptions.byRevenueLowToHigh;
  }
}
