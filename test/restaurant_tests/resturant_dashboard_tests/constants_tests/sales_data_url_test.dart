import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/constants/base_urls.dart';
import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/constants/restaurant_dashboard_urls.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_break_down_wise_options.dart';

main() {
  var dateRangeFilter = DateRangeFilters();
  var selectedWise = SalesBreakDownWiseOptions.basedOnOrder;

  test("creating sales breakdown url when selected wise is category wise", () {
    selectedWise = SalesBreakDownWiseOptions.basedOnCategory;

    var url = RestaurantDashboardUrls.getSalesBreakDownsUrl("1", selectedWise, dateRangeFilter);

    expect(url,
        '${BaseUrls.restaurantUrlV2()}/companies/1/store/0/consolidated_stats/sales_breakdown/by/category/mobile?date_filter_type=today');
  });

  test("creating sales breakdown url when selected wise is menu item wise", () {
    selectedWise = SalesBreakDownWiseOptions.basedOnMenu;

    var url = RestaurantDashboardUrls.getSalesBreakDownsUrl("1", selectedWise, dateRangeFilter);

    expect(url,
        '${BaseUrls.restaurantUrlV2()}/companies/1/store/0/consolidated_stats/sales_breakdown/by/menu_item/mobile?date_filter_type=today');
  });

  test("creating sales breakdown url when selected wise is order wise", () {
    selectedWise = SalesBreakDownWiseOptions.basedOnOrder;

    var url = RestaurantDashboardUrls.getSalesBreakDownsUrl("1", selectedWise, dateRangeFilter);

    expect(url,
        '${BaseUrls.restaurantUrlV2()}/companies/1/store/0/consolidated_stats/sales_breakdown/by/order_type/mobile?date_filter_type=today');
  });

  test("creating sales breakdown url url when selected date filter is today", () {
    dateRangeFilter.setSelectedDateRangeOption(SelectableDateRangeOptions.today);

    var url = RestaurantDashboardUrls.getSalesBreakDownsUrl("1", selectedWise, dateRangeFilter);

    expect(url,
        '${BaseUrls.restaurantUrlV2()}/companies/1/store/0/consolidated_stats/sales_breakdown/by/order_type/mobile?date_filter_type=today');
  });

  test("creating sales breakdown url when selected date filter is yesterday", () {
    dateRangeFilter.setSelectedDateRangeOption(SelectableDateRangeOptions.yesterday);

    var url = RestaurantDashboardUrls.getSalesBreakDownsUrl("1", selectedWise, dateRangeFilter);

    expect(url,
        '${BaseUrls.restaurantUrlV2()}/companies/1/store/0/consolidated_stats/sales_breakdown/by/order_type/mobile?date_filter_type=yesterday');
  });

  test("creating sales breakdown url when selected date filter is this week", () {
    dateRangeFilter.setSelectedDateRangeOption(SelectableDateRangeOptions.thisWeek);

    var url = RestaurantDashboardUrls.getSalesBreakDownsUrl("1", selectedWise, dateRangeFilter);

    expect(url,
        '${BaseUrls.restaurantUrlV2()}/companies/1/store/0/consolidated_stats/sales_breakdown/by/order_type/mobile?date_filter_type=this_week');
  });

  test("creating sales breakdown url when selected date filter is this month", () {
    dateRangeFilter.setSelectedDateRangeOption(SelectableDateRangeOptions.thisMonth);
    dateRangeFilter.startDate = DateTime.now();
    dateRangeFilter.endDate = DateTime.now().subtract(Duration(days: 30));

    var url = RestaurantDashboardUrls.getSalesBreakDownsUrl("1", selectedWise, dateRangeFilter);

    expect(url,
        '${BaseUrls.restaurantUrlV2()}/companies/1/store/0/consolidated_stats/sales_breakdown/by/order_type/mobile?date_filter_type=date_between&start_date=${dateRangeFilter.startDate.yyyyMMddString()}&end_date=${dateRangeFilter.endDate.yyyyMMddString()}');
  });

  test("creating sales breakdown url when selected date filter is this year", () {
    dateRangeFilter.setSelectedDateRangeOption(SelectableDateRangeOptions.thisYear);

    var url = RestaurantDashboardUrls.getSalesBreakDownsUrl("1", selectedWise, dateRangeFilter);

    expect(url,
        '${BaseUrls.restaurantUrlV2()}/companies/1/store/0/consolidated_stats/sales_breakdown/by/order_type/mobile?date_filter_type=this_year');
  });

  test("creating sales breakdown url when selected date filter is last year", () {
    dateRangeFilter.setSelectedDateRangeOption(SelectableDateRangeOptions.lastYear);

    var url = RestaurantDashboardUrls.getSalesBreakDownsUrl("1", selectedWise, dateRangeFilter);

    expect(url,
        '${BaseUrls.restaurantUrlV2()}/companies/1/store/0/consolidated_stats/sales_breakdown/by/order_type/mobile?date_filter_type=last_year');
  });

  test("creating the url when selected date filter is custom", () {
    dateRangeFilter.setSelectedDateRangeOption(SelectableDateRangeOptions.custom);
    dateRangeFilter.startDate = DateTime.now().subtract(Duration(days: 10));
    dateRangeFilter.endDate = DateTime.now().subtract(Duration(days: 1));

    var url = RestaurantDashboardUrls.getSalesBreakDownsUrl("1", selectedWise, dateRangeFilter);

    expect(url,
        '${BaseUrls.restaurantUrlV2()}/companies/1/store/0/consolidated_stats/sales_breakdown/by/order_type/mobile?date_filter_type=date_between&start_date=${dateRangeFilter.startDate.yyyyMMddString()}&end_date=${dateRangeFilter.endDate.yyyyMMddString()}');
  });
}
