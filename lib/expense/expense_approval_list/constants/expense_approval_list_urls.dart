import '../../../_shared/constants/base_urls.dart';

class ExpenseApprovalListUrls {
  static String pendingApprovalListUrl(String companyId, int pageNumber, int itemsPerPage) {
    var url = '${BaseUrls.hrUrlV2()}/companies/$companyId/finance/expense/approvals';
    url += "?type=pending&page=$pageNumber&perPage=$itemsPerPage";
    return url;
  }
}
