
import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';

import '../../../../_shared/constants/base_urls.dart';

class SummarySalesUrls {
  static String getSummarySalesUrl(String companyId, DateRange dateRange) {
    var url = '${BaseUrls.restaurantUrlV2()}/companies/$companyId/store/0/salessummaryreport?';
    url += '&consumedByMobile=true';
    url += '&date_filter_type=date_between&from_date=${dateRange.startDate.yyyyMMddString()}&to_date=${dateRange.endDate.yyyyMMddString()}';
    return url;
  }
}
