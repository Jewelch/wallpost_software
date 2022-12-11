import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/entities/sales_item_view_options.dart';

import '../../../../_shared/constants/base_urls.dart';

class ItemSalesUrls {
  static String getSalesItemUrl(
    SalesItemWiseOptions salesItemOptions,
    String companyId,
    String storeId,
    DateRangeFilters dateFilters,
  ) {
    var url = '${BaseUrls.restaurantUrlV2()}/companies/$companyId/store/$storeId/itemsalesreport/filters?';
    // if (dateFilters.selectedRangeOption == SelectableDateRangeOptions.custom ||
    //     dateFilters.selectedRangeOption == SelectableDateRangeOptions.thisMonth) {
    url += "date=${dateFilters.startDate.yyyyMMddString()}";
    url += "&filter_type=${salesItemOptions.toRawString()}";
    //}
    return url;
  }
}
