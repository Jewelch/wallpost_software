import 'package:wallpost/_shared/constants/base_urls.dart';
import 'package:wallpost/expense_list/entities/expense_requests_filters.dart';

class ExpenseListUrls {
  static String getEmployeeExpenses(
      String companyId, int pageNum, int perPage, ExpenseRequestsFilters filter) {
    return '${BaseUrls.hrUrlV3()}/companies/$companyId/finance/expense/list?page=$pageNum&perPage=$perPage&type=${filter.toReadableString()}';
  }
}
