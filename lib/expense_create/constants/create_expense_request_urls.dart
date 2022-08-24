import '../../_shared/constants/base_urls.dart';

class CreateExpenseRequestUrls {
  static String getExpenseCategoriesUrl(String companyId) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/finance/expense/categories';
  }

  static String getCreateExpenseRequestUrl(String companyId) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/finance/expense/request';
  }
}
