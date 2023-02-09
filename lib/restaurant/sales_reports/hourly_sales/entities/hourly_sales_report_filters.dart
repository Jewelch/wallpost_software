import 'package:wallpost/_shared/extensions/date_extensions.dart';

import 'hourly_sales_report_sort_options.dart';

class HourlySalesReportFilters {
  DateTime selectedDate = DateTime.now();
  HourlySalesReportSortOptions sortOption = HourlySalesReportSortOptions.byRevenueLowToHigh;

  HourlySalesReportFilters copy() {
    var itemSalesFilters = HourlySalesReportFilters();
    itemSalesFilters.selectedDate = selectedDate;
    itemSalesFilters.sortOption = sortOption;
    return itemSalesFilters;
  }

  List<String> toReadableListOfString() {
    return [selectedDate.toReadableString(), sortOption.toReadableString()];
  }

  void reset() {
    selectedDate = DateTime.now();
    sortOption = HourlySalesReportSortOptions.byRevenueLowToHigh;
  }
}
