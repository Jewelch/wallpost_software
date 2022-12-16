import '../../../../_shared/constants/base_urls.dart';

class ItemSalesUrls {
  static String getSalesItemUrl(
    // SalesItemWiseOptions salesItemOptions,
    String companyId,
    String storeId,
    //  DateRangeFilters dateFilters,
  ) {
    var url = '${BaseUrls.restaurantUrlV2()}/companies/52/store/$storeId/itemsalesreport/filters?';
    // if (dateFilters.selectedRangeOption == SelectableDateRangeOptions.custom ||
    //     dateFilters.selectedRangeOption == SelectableDateRangeOptions.thisMonth) {
    url += "date=2022-8-1";
    // dateFilters.startDate.yyyyMMddString()
    url += "&filter_type=category_item_wise";
    //}
    return url;
  }
}
