import 'package:wallpost/_shared/constants/base_urls.dart';

import '../entities/expense_request_approval_status_filter.dart';

class ExpenseListUrls {
  static String getExpenseListUrl(
    String companyId,
    int pageNum,
    int perPage,
    ExpenseRequestApprovalStatusFilter statusFilter,
  ) {
    var url = '${BaseUrls.hrUrlV2()}/companies/$companyId/finance/expense/list?page=$pageNum&perPage=$perPage}';
    if (statusFilter != ExpenseRequestApprovalStatusFilter.all) url += "&type=${statusFilter.toRawString()}";
    return url;
  }
}
