import '../../../../_shared/constants/base_urls.dart';
import '../../../../_shared/extensions/date_extensions.dart';
import '../entities/hourly_sales_report_filters.dart';

class HourlySalesUrls {
  static String getHourSalesUrl(String companyId, HourlySalesReportFilters filters) {
    var selectedDate = filters.selectedDate;

    var url =
        '${BaseUrls.restaurantUrlV2()}/companies/$companyId/store/0/hourlysalesreport?from_date=${selectedDate.yyyyMMddString()}'
        '&to_date=${selectedDate.yyyyMMddString()}';

    url += '&consumedByMobile=true';
    url += '&sortByRevenue=${filters.sortOption.toRawString()}';
    url += '&page=1&perPage=24';

    return url;
  }
}
