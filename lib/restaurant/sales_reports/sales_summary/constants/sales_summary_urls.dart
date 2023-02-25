
import '../../../../_shared/constants/base_urls.dart';
import '../entities/summary_sales_report_filters.dart';

class SummarySalesUrls {
  static String getSummarySalesUrl(String companyId, SummarySalesReportFilters filters) {
    var selectedDate = filters.selectedDate;
    var url = '${BaseUrls.restaurantUrlV2()}/companies/$companyId/store/0/salessummaryreport?';
    url += '&consumedByMobile=true';
    url += '&date_filter_type=date_between&from_date=2023-01-03&to_date=2023-02-10';
    return url;
  }
}
