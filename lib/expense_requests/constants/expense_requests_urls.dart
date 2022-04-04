import 'package:wallpost/_shared/constants/base_urls.dart';

class ExpenseRequestsUrls {
  static String getExpenseCategoriesUrl(String companyId) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/finance/expense/categories';
  }

  static String getExpenseAddingUrl(String companyId) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/finance/expense/request';
  }
}
