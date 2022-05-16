import 'package:wallpost/_shared/constants/base_urls.dart';

import '../entities/expense_request_status_filter.dart';

class ExpenseListUrls {
  static String getEmployeeExpenses(String companyId, int pageNum, int perPage, ExpenseRequestStatusFilter filter) {
    return '${BaseUrls.hrUrlV3()}/companies/$companyId/finance/expense/list?page=$pageNum&perPage=$perPage&type=${filter.toRawString()}';
  }
}
