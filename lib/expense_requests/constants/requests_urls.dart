import 'package:wallpost/_shared/constants/base_urls.dart';

class RequestsUrls {
  static String getExpenseRequestUrl(String companyId) {
    return '${BaseUrls.hrUrlV2()}/$companyId/finance/expense/categories';
  }
}
