import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';
import 'package:wallpost/_shared/date_range_selector/entities/selectable_date_range_option.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/item_sales/entities/item_sales_report_sort_options.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/item_sales/entities/sales_item_view_options.dart';

DateRange getDifferentDateRangeOption(DateRange oldDateRangeFilters) {
  DateRange newDateFilter = DateRange();
  if (SelectableDateRangeOptions.thisYear == newDateFilter.selectedRangeOption) {
    newDateFilter.selectedRangeOption = SelectableDateRangeOptions.thisMonth;
  } else {
    newDateFilter.selectedRangeOption = SelectableDateRangeOptions.thisYear;
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
