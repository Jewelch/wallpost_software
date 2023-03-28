import '../../../../_shared/date_range_selector/date_range_filters.dart';
import 'item_sales_report_sort_options.dart';
import 'sales_item_view_options.dart';

class ItemSalesReportFilters {
  DateRange dateFilters = DateRange();
  SalesItemWiseOptions salesItemWiseOptions = SalesItemWiseOptions.CategoriesAndItems;
  ItemSalesReportSortOptions sortOption = ItemSalesReportSortOptions.byRevenueLowToHigh;

  ItemSalesReportFilters copy() {
    var itemSalesFilters = ItemSalesReportFilters();
    itemSalesFilters.dateFilters = dateFilters.copy();
    itemSalesFilters.salesItemWiseOptions = salesItemWiseOptions;
    itemSalesFilters.sortOption = sortOption;
    return itemSalesFilters;
  }

  List<String> toReadableListOfString() {
    return [
      dateFilters.toReadableString(),
      salesItemWiseOptions.toReadableString(),
      sortOption.toReadableString()
    ];
  }

  void reset(){
    dateRangeFilters = DateRangeFilters();
    salesItemWiseOptions = SalesItemWiseOptions.CategoriesAndItems;
    sortOption = ItemSalesReportSortOptions.byRevenueLowToHigh;
  }
}
