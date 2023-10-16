import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';

import '../../../../../_shared/constants/base_urls.dart';

class OrderDetailsUrls {
  static String details(String companyId, int orderId, DateRange range) {
    var url = '${BaseUrls.restaurantUrlV2()}/companies/$companyId/store/0/orders-summary-report/details/$orderId';
    url += '?consumedByMobile=true&date_filter_type=date_between';
    url += '&from_date=${range.startDate.yyyyMMddString()}';
    url += '&to_date=${range.endDate.yyyyMMddString()}';
    return url;
  }
}
