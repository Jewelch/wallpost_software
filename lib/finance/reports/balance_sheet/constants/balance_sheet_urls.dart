import 'package:wallpost/_shared/extensions/date_extensions.dart';

import '../../../../_shared/constants/base_urls.dart';
import '../../../../_shared/date_range_selector/entities/date_range.dart';

class BalanceSheetUrls {
  static String getBalanceSheetUrl(
    String companyId,
    DateRange dateRange,
  ) {
    var url = '${BaseUrls.financeUrlV2()}/companies/$companyId/reports/balance_sheet';
    url += '?consumedByMobile=true';
    url +=
        '&range=custom&from_date=${dateRange.startDate.yyyyMMddString()}&to_date=${dateRange.endDate.yyyyMMddString()}';
    return url;
  }
}
