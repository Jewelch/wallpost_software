import 'package:wallpost/_shared/constants/base_urls.dart';

class ExpenseListUrls {
  static String getEmployeeExpenses(String companyId) {
    return '${BaseUrls.hrUrlV3()}/companies/$companyId/finance/expense/list';
  }
}
