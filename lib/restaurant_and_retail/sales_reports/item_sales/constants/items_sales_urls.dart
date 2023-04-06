import 'package:wallpost/_shared/extensions/date_extensions.dart';

import '../../../../_shared/constants/base_urls.dart';
import '../../../../_shared/date_range_selector/entities/date_range.dart';

class ItemSalesUrls {
  static String getSalesItemUrl(
    String companyId,
    DateRange dateRange,
  ) {
    var url = '${BaseUrls.restaurantUrlV2()}/companies/$companyId/store/0/itemsalesreport/filters';

    url +=
        '?date_filter_type=date_between&start_date=${dateRange.startDate.yyyyMMddString()}&end_date=${dateRange.endDate.yyyyMMddString()}';

    return url;
  }
}
