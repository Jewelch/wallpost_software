import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/constants/base_urls.dart';
import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/constants/items_sales_urls.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/entities/sales_item_view_options.dart';

main() {
  var dateRangeFilter = DateRangeFilters();
  var selectedWise = SalesItemWiseOptions.viewAsCategory;
  var datetime = DateTime.now().yyyyMMddString();

  test("creating item sales breakdown url when selected wise is category item view", () {
    selectedWise = SalesItemWiseOptions.viewAsCategory;

    var url = ItemSalesUrls.getSalesItemUrl(selectedWise, "1", "0", dateRangeFilter);

    expect(url,
        '${BaseUrls.restaurantUrlV2()}/companies/1/store/0/itemsalesreport/filters?date=$datetime&filter_type=category_wise');
  });
  test("creating item sales breakdown url when selected wise is menu item view", () {
    selectedWise = SalesItemWiseOptions.viewAsItem;

    var url = ItemSalesUrls.getSalesItemUrl(selectedWise, "1", "0", dateRangeFilter);

    expect(url,
        '${BaseUrls.restaurantUrlV2()}/companies/1/store/0/itemsalesreport/filters?date=$datetime&filter_type=menu_item_wise');
  });
  test("creating item sales breakdown url when selected wise is category and item view", () {
    selectedWise = SalesItemWiseOptions.viewAsCategoryAndItem;

    var url = ItemSalesUrls.getSalesItemUrl(selectedWise, "1", "0", dateRangeFilter);

    expect(url,
        '${BaseUrls.restaurantUrlV2()}/companies/1/store/0/itemsalesreport/filters?date=$datetime&filter_type=category_item_wise');
  });
}
