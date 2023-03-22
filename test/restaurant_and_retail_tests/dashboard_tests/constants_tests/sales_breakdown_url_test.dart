import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/constants/base_urls.dart';
import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/restaurant_and_retail/dashboard/constants/dashboard_urls.dart';
import 'package:wallpost/restaurant_and_retail/dashboard/ui/views/screens/dashboard_screen.dart';

main() {
  var dateRangeFilter = DateRangeFilters();

  test("creating aggregated sales data url when selected date filter is today", () {
    dateRangeFilter.setSelectedDateRangeOption(SelectableDateRangeOptions.today);

    var url = DashboardUrls.getSalesAmountsUrl("1", dateRangeFilter, DashboardContext.restaurant);

    expect(url,
        "${BaseUrls.restaurantUrlV2()}/companies/1/store/0/consolidated_stats/sales_data/dashboard?date_filter_type=today");

    url = DashboardUrls.getSalesAmountsUrl("1", dateRangeFilter, DashboardContext.retail);
    expect(url,
        "${BaseUrls.restaurantUrlV2()}/companies/1/store/0/consolidated_stats/sales_data/dashboard?date_filter_type=today&forRetail=true");
  });

  test("creating aggregated sales data url when selected date filter is yesterday", () {
    dateRangeFilter.setSelectedDateRangeOption(SelectableDateRangeOptions.yesterday);

    var url = DashboardUrls.getSalesAmountsUrl("1", dateRangeFilter, DashboardContext.restaurant);

    expect(url,
        "${BaseUrls.restaurantUrlV2()}/companies/1/store/0/consolidated_stats/sales_data/dashboard?date_filter_type=yesterday");
  });

  test("creating aggregated sales data url when selected date filter is this week", () {
    dateRangeFilter.setSelectedDateRangeOption(SelectableDateRangeOptions.thisWeek);

    var url = DashboardUrls.getSalesAmountsUrl("1", dateRangeFilter, DashboardContext.restaurant);

    expect(url,
        "${BaseUrls.restaurantUrlV2()}/companies/1/store/0/consolidated_stats/sales_data/dashboard?date_filter_type=this_week");
  });

  test("creating aggregated sales data url when selected date filter is this month", () {
    dateRangeFilter.setSelectedDateRangeOption(SelectableDateRangeOptions.thisMonth);

    var url = DashboardUrls.getSalesAmountsUrl("1", dateRangeFilter, DashboardContext.restaurant);

    expect(url,
        "${BaseUrls.restaurantUrlV2()}/companies/1/store/0/consolidated_stats/sales_data/dashboard?date_filter_type=date_between&start_date=${dateRangeFilter.startDate.yyyyMMddString()}&end_date=${dateRangeFilter.endDate.yyyyMMddString()}");
  });

  test("creating aggregated sales data url when selected date filter is this year", () {
    dateRangeFilter.setSelectedDateRangeOption(SelectableDateRangeOptions.thisYear);

    var url = DashboardUrls.getSalesAmountsUrl("1", dateRangeFilter, DashboardContext.restaurant);

    expect(url,
        "${BaseUrls.restaurantUrlV2()}/companies/1/store/0/consolidated_stats/sales_data/dashboard?date_filter_type=this_year");
  });

  test("creating aggregated sales data url when selected date filter is last year", () {
    dateRangeFilter.setSelectedDateRangeOption(SelectableDateRangeOptions.lastYear);

    var url = DashboardUrls.getSalesAmountsUrl("1", dateRangeFilter, DashboardContext.restaurant);

    expect(url,
        "${BaseUrls.restaurantUrlV2()}/companies/1/store/0/consolidated_stats/sales_data/dashboard?date_filter_type=last_year");
  });

  test("creating the url when selected date url filter is custom", () {
    dateRangeFilter.setSelectedDateRangeOption(SelectableDateRangeOptions.custom);
    dateRangeFilter.startDate = DateTime.now().subtract(Duration(days: 10));
    dateRangeFilter.endDate = DateTime.now().subtract(Duration(days: 1));

    var url = DashboardUrls.getSalesAmountsUrl("1", dateRangeFilter, DashboardContext.restaurant);

    expect(url,
        "${BaseUrls.restaurantUrlV2()}/companies/1/store/0/consolidated_stats/sales_data/dashboard?date_filter_type=date_between&start_date=${dateRangeFilter.startDate.yyyyMMddString()}&end_date=${dateRangeFilter.endDate.yyyyMMddString()}");
  });
}
