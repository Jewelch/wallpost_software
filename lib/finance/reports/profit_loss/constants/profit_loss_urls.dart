import 'package:wallpost/_shared/extensions/date_extensions.dart';

import '../../../../_shared/constants/base_urls.dart';
import '../../../../_shared/date_range_selector/entities/date_range.dart';

class ProfitsLossesUrls {
  static String getProfitsLossesUrl(
    String companyId,
    DateRange dateRange,
  ) {
    var url = '${BaseUrls.financeUrlV2()}/companies/$companyId/reports/profit-loss/list';

    url +=
        '?date_filter_type=date_between&from_date=${dateRange.startDate.yyyyMMddString()}&to_date=${dateRange.endDate.yyyyMMddString()}';

    return url;
  }
}
