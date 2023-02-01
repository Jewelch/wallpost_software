import '../../../../_shared/constants/base_urls.dart';
import '../../../../_shared/date_range_selector/date_range_filters.dart';
import '../../../../_shared/extensions/date_extensions.dart';

class HourlySalesUrls {
  static String getSalesItemUrl(
      String companyId, DateRangeFilters dateFilters, int pageNumber, int itemsPerPage, bool sortAscending) {
    var url =
        '${BaseUrls.restaurantUrlV2()}/companies/52/store/0/hourlysalesreport?date_filter_type=${dateFilters.selectedRangeOption.toRawString()}';

    if (dateFilters.selectedRangeOption == SelectableDateRangeOptions.custom ||
        dateFilters.selectedRangeOption == SelectableDateRangeOptions.thisMonth) {
      url += "&from_date=${dateFilters.startDate.yyyyMMddString()}";
      url += "&to_date=${dateFilters.endDate.yyyyMMddString()}";
    }

    url += '&consumedByMobile=true';
    url += '&sortByRevenue=${sortAscending ? 'asc' : 'desc'}';
    url += '&page=$pageNumber&perPage=$itemsPerPage';

    return url;
  }
}


// https://restaurant.stagingapi.wallpostsoftware.com/api/v2/companies/{company_id}/store/0/hourlysalesreport?perPage=50&from_date=2023-01-03&to_date=2023-01-03
