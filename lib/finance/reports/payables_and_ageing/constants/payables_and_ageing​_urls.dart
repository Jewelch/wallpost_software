
import '../../../../_shared/constants/base_urls.dart';

class PayablesUrls {
  static String getUrl(String companyId) {
    var url = '${BaseUrls.financeUrlV2()}/companies/$companyId/accounts/aged-payables?consumedByMobile=true';
    return url;
  }
}
