import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/item_sales/entities/item_sales_report_sort_options.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/item_sales/entities/sales_item_view_options.dart';

DateRangeFilters getDifferentDateRangeOption(DateRangeFilters oldDateRangeFilters) {
  DateRangeFilters newDateFilter = DateRangeFilters();
  if (SelectableDateRangeOptions.thisYear == newDateFilter.selectedRangeOption) {
    newDateFilter.setSelectedDateRangeOption(SelectableDateRangeOptions.thisMonth);
  } else {
    newDateFilter.setSelectedDateRangeOption(SelectableDateRangeOptions.thisYear);
  }
  return newDateFilter;
}

ItemSalesReportSortOptions getDifferentItemSaleSortFilter(ItemSalesReportSortOptions sortOption) {
  if (ItemSalesReportSortOptions.byNameZToA == sortOption) {
    return ItemSalesReportSortOptions.byNameAToZ;
  } else {
    return ItemSalesReportSortOptions.byNameZToA;
  }
}

SalesItemWiseOptions getDifferentItemSaleViewFilter(SalesItemWiseOptions salesItemWiseOptions) {
  if (SalesItemWiseOptions.itemsOnly == salesItemWiseOptions) {
    return SalesItemWiseOptions.CategoriesAndItems;
  } else {
    return SalesItemWiseOptions.itemsOnly;
  }
}
