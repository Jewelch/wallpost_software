import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';

import '../../../../../_shared/constants/base_urls.dart';

class OrdersSummaryUrls {
  static String ordersSummaryList(String companyId, DateRange range, int currentPage, int perPage) {
    var url =
        '${BaseUrls.restaurantUrlV2()}/companies/$companyId/store/0/orders-summary-report/list?date_filter_type=date_between'
        '&from_date=${range.startDate.yyyyMMddString()}'
        '&to_date=${range.endDate.yyyyMMddString()}';
    url += '&consumedByMobile=true';
    url += '&page=$currentPage&perPage=$perPage';
    return url;
  }
}
