import '../../_shared/constants/base_urls.dart';

class ExpenseDetailUrls {
  static String getExpenseDetailUrl(String companyId, String expenseId) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/finance/expense/$expenseId';
  }
}
