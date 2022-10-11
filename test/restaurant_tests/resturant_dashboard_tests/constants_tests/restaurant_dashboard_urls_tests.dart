import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/constants/base_urls.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/constants/restaurant_dashboard_urls.dart';
import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';

main() {
  var dateRangeFilter = DateRangeFilters();

  test("creating the url when selected date filter is today", () {
    dateRangeFilter.selectedRangeOption = SelectableDateRangeOptions.today;

    var url = RestaurantDashboardUrls.getSalesAmountsUrl("1", "1", dateRangeFilter);

    expect(url, "${BaseUrls.hrUrlV2()}/companies/1/store/1/consolidated_stats/sales_data?date_filter_type=today");
  });

  test("creating the url when selected date filter is yesterday", () {
    dateRangeFilter.selectedRangeOption = SelectableDateRangeOptions.yesterday;

    var url = RestaurantDashboardUrls.getSalesAmountsUrl("1", "1", dateRangeFilter);

    expect(url, "${BaseUrls.hrUrlV2()}/companies/1/store/1/consolidated_stats/sales_data?date_filter_type=yesterday");
  });

  test("creating the url when selected date filter is this week", () {
    dateRangeFilter.selectedRangeOption = SelectableDateRangeOptions.thisWeek;

    var url = RestaurantDashboardUrls.getSalesAmountsUrl("1", "1", dateRangeFilter);

    expect(url, "${BaseUrls.hrUrlV2()}/companies/1/store/1/consolidated_stats/sales_data?date_filter_type=this_week");
  });

  test("creating the url when selected date filter is this month", () {
    dateRangeFilter.selectedRangeOption = SelectableDateRangeOptions.thisMonth;

    var url = RestaurantDashboardUrls.getSalesAmountsUrl("1", "1", dateRangeFilter);

    expect(url, "${BaseUrls.hrUrlV2()}/companies/1/store/1/consolidated_stats/sales_data?date_filter_type=this_month");
  });

  test("creating the url when selected date filter is this year", () {
    dateRangeFilter.selectedRangeOption = SelectableDateRangeOptions.thisYear;

    var url = RestaurantDashboardUrls.getSalesAmountsUrl("1", "1", dateRangeFilter);

    expect(url, "${BaseUrls.hrUrlV2()}/companies/1/store/1/consolidated_stats/sales_data?date_filter_type=this_year");
  });

  test("creating the url when selected date filter is last year", () {
    dateRangeFilter.selectedRangeOption = SelectableDateRangeOptions.lastYear;

    var url = RestaurantDashboardUrls.getSalesAmountsUrl("1", "1", dateRangeFilter);

    expect(url, "${BaseUrls.hrUrlV2()}/companies/1/store/1/consolidated_stats/sales_data?date_filter_type=last_year");
  });

  test("creating the url when selected date filter is Custom", () {
    dateRangeFilter.selectedRangeOption = SelectableDateRangeOptions.custom;
    dateRangeFilter.startDate = DateTime.now().subtract(Duration(days: 10));
    dateRangeFilter.endDate = DateTime.now().subtract(Duration(days: 1));

    var url = RestaurantDashboardUrls.getSalesAmountsUrl("1", "1", dateRangeFilter);

    expect(url,
        "${BaseUrls.hrUrlV2()}/companies/1/store/1/consolidated_stats/sales_data?date_filter_type=date&start_date=${dateRangeFilter.startDate.yMMMd}&end_date=${dateRangeFilter.endDate.yMMMd}");
  });
}
