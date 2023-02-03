import '../../../../_shared/constants/base_urls.dart';
import '../../../../_shared/date_range_selector/date_range_filters.dart';
import '../../../../_shared/extensions/date_extensions.dart';

class ItemSalesUrls {
  static String getSalesItemUrl(
    String companyId,
    DateRangeFilters dateFilters,
  ) {
    var url =
        '${BaseUrls.restaurantUrlV2()}/companies/$companyId/store/0/itemsalesreport/filters?date_filter_type=${dateFilters.selectedRangeOption.toRawString()}';

    if (dateFilters.selectedRangeOption == SelectableDateRangeOptions.custom ||
        dateFilters.selectedRangeOption == SelectableDateRangeOptions.thisMonth) {
      url += "&start_date=${dateFilters.startDate.yyyyMMddString()}";
      url += "&end_date=${dateFilters.endDate.yyyyMMddString()}";
    }

    return url;
  }
}
