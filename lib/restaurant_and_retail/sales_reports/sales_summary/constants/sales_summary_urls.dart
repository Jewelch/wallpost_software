import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';

import '../../../../_shared/constants/base_urls.dart';

class SummarySalesUrls {
  static String getSummarySalesUrl(String companyId, DateRangeFilters filters) {
    var url = '${BaseUrls.restaurantUrlV2()}/companies/$companyId/store/0/salessummaryreport?';
    url += '&consumedByMobile=true';
    url +=
        '&date_filter_type=date_between&from_date=${filters.startDate.yyyyMMddString()}&to_date=${filters.endDate.yyyyMMddString()}';
    return url;
  }
}
