import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/constants/base_urls.dart';
import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/constants/items_sales_urls.dart';

main() {
  var dateRangeFilter = DateRangeFilters();

  test("creating items sales data url when selected date filter is today", () {
    dateRangeFilter.setSelectedDateRangeOption(SelectableDateRangeOptions.today);

    var url = ItemSalesUrls.getSalesItemUrl("1", dateRangeFilter);

    expect(url,
        "${BaseUrls.restaurantUrlV2()}/companies/1/store/0/itemsalesreport/filters?date_filter_type=today");
  });

  test("creating item sales data url when selected date filter is yesterday", () {
    dateRangeFilter.setSelectedDateRangeOption(SelectableDateRangeOptions.yesterday);

    var url = ItemSalesUrls.getSalesItemUrl("1", dateRangeFilter);

    expect(url,
        "${BaseUrls.restaurantUrlV2()}/companies/1/store/0/itemsalesreport/filters?date_filter_type=yesterday");
  });

  test("creating item sales data url when selected date filter is this week", () {
    dateRangeFilter.setSelectedDateRangeOption(SelectableDateRangeOptions.thisWeek);

    var url = ItemSalesUrls.getSalesItemUrl("1", dateRangeFilter);

    expect(url,
        "${BaseUrls.restaurantUrlV2()}/companies/1/store/0/itemsalesreport/filters?date_filter_type=this_week");
  });

  test("creating item sales data url when selected date filter is this month", () {
    dateRangeFilter.setSelectedDateRangeOption(SelectableDateRangeOptions.thisMonth);

    var url = ItemSalesUrls.getSalesItemUrl("1", dateRangeFilter);

    expect(url,
        "${BaseUrls.restaurantUrlV2()}/companies/1/store/0/itemsalesreport/filters?date_filter_type=date_between&start_date=${dateRangeFilter.startDate.yyyyMMddString()}&end_date=${dateRangeFilter.endDate.yyyyMMddString()}");
  });

  test("creating item sales data url when selected date filter is this year", () {
    dateRangeFilter.setSelectedDateRangeOption(SelectableDateRangeOptions.thisYear);

    var url = ItemSalesUrls.getSalesItemUrl("1", dateRangeFilter);

    expect(url,
        "${BaseUrls.restaurantUrlV2()}/companies/1/store/0/itemsalesreport/filters?date_filter_type=this_year");
  });

  test("creating item sales data url when selected date filter is last year", () {
    dateRangeFilter.setSelectedDateRangeOption(SelectableDateRangeOptions.lastYear);

    var url = ItemSalesUrls.getSalesItemUrl("1", dateRangeFilter);

    expect(url,
        "${BaseUrls.restaurantUrlV2()}/companies/1/store/0/itemsalesreport/filters?date_filter_type=last_year");
  });

  test("creating the url when selected date url filter is custom", () {
    var startDate = DateTime.now().subtract(Duration(days: 10));
    var endDate = DateTime.now().subtract(Duration(days: 1));
    dateRangeFilter.setSelectedDateRangeOption(SelectableDateRangeOptions.custom,
        customStartDate: startDate, customEndDate: endDate);

    var url = ItemSalesUrls.getSalesItemUrl("1", dateRangeFilter);

    expect(url,
        "${BaseUrls.restaurantUrlV2()}/companies/1/store/0/itemsalesreport/filters?date_filter_type=date_between&start_date=${dateRangeFilter.startDate.yyyyMMddString()}&end_date=${dateRangeFilter.endDate.yyyyMMddString()}");
  });
}
