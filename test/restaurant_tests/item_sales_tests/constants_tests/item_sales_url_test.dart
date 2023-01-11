import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/entities/sales_item_view_options.dart';

main() {
  var dateRangeFilter = DateRangeFilters();
  var selectedWise = SalesItemWiseOptions.CategoriesOnly;
  var datetime = DateTime.now().yyyyMMddString();

//?  Will do this after filter implementation

  // test("creating item sales breakdown url when selected wise is category item view", () {
  //   selectedWise = SalesItemWiseOptions.viewAsCategory;

  //   var url = ItemSalesUrls.getSalesItemUrl("1", "0");

  //   expect(url,
  //       '${BaseUrls.restaurantUrlV2()}/companies/1/store/0/itemsalesreport/filters?date=$datetime&filter_type=category_wise');
  // });
}
