import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/entities/item_sales_report_sort_options.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/entities/sales_item_view_options.dart';

class ItemSalesReportFilters {
  DateRangeFilters dateRangeFilters = DateRangeFilters();
  SalesItemWiseOptions salesItemWiseOptions = SalesItemWiseOptions.itemsOnly;
  ItemSalesReportSortOptions sortOptions = ItemSalesReportSortOptions.byRevenueHighToLow;

  ItemSalesReportFilters copy() {
    var itemSalesFilters = ItemSalesReportFilters();
    itemSalesFilters.dateRangeFilters = dateRangeFilters.copy();
    itemSalesFilters.salesItemWiseOptions = salesItemWiseOptions;
    itemSalesFilters.sortOptions = sortOptions;
    return itemSalesFilters;
  }

  List<String> toReadableListOfString() {
    return [
      dateRangeFilters.selectedRangeOption.toReadableString(),
      salesItemWiseOptions.toReadableString(),
      sortOptions.toReadableString()
    ];
  }
}
