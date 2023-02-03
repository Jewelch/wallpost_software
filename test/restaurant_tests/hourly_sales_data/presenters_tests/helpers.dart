import 'package:wallpost/restaurant/sales_reports/hourly_sales/entities/hourly_sales_report_sort_options.dart';

DateTime getDifferentDate(DateTime dateTime) {
  return dateTime.subtract(Duration(days: 20));
}

HourlySalesReportSortOptions getDifferentHourlySaleSortFilter(HourlySalesReportSortOptions sortOption) {
  if (HourlySalesReportSortOptions.byRevenueLowToHigh == sortOption) {
    return HourlySalesReportSortOptions.byRevenueHighToLow;
  } else {
    return HourlySalesReportSortOptions.byRevenueLowToHigh;
  }
}
