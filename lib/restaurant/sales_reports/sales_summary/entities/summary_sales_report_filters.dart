import '../../../../_shared/extensions/date_extensions.dart';
import 'sales_summary_report_sort_options.dart';

class SummarySalesReportFilters {
  DateTime selectedDate = DateTime.now();
  HourlySalesReportSortOptions sortOption = HourlySalesReportSortOptions.byRevenueLowToHigh;

  SummarySalesReportFilters copy() {
    var itemSalesFilters = SummarySalesReportFilters();
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
