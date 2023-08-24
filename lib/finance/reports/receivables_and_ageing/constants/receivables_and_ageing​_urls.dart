
import '../../../../_shared/constants/base_urls.dart';

class ReceivablesUrls {
  static String getUrl(String companyId) {
    var url = '${BaseUrls.financeUrlV2()}/companies/$companyId/accounts/aged-receivables?consumedByMobile=true';
    return url;
  }
}
