import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/constants/base_urls.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/constants/restaurant_dashboard_urls.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_break_down_filtering_strategies.dart';

main() {
  test("creating sales breakdown url when selected wise is order wise", () {
    var selectedWise = SalesBreakdownFilteringStrategies.basedOnOrder;

    var url = RestaurantDashboardUrls.getSalesBreakDownsUrl("1", selectedWise);

    expect(url, '${BaseUrls.hrUrlV2()}/companies/1/store/0/consolidated_stats/sales_breakdown/by/order_type');
  });

  test("creating sales breakdown when selected wise is category wise", () {
    var selectedWise = SalesBreakdownFilteringStrategies.basedOnCategory;

    var url = RestaurantDashboardUrls.getSalesBreakDownsUrl("1", selectedWise);

    expect(url, '${BaseUrls.hrUrlV2()}/companies/1/store/0/consolidated_stats/sales_breakdown/by/category');
  });

  test("creating sales breakdown when selected wise is menu item wise", () {
    var selectedWise = SalesBreakdownFilteringStrategies.basedOnMenu;

    var url = RestaurantDashboardUrls.getSalesBreakDownsUrl("1", selectedWise);

    expect(url, '${BaseUrls.hrUrlV2()}/companies/1/store/0/consolidated_stats/sales_breakdown/by/menu_item');
  });
}
