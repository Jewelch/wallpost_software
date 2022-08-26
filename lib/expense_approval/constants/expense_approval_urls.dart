import '../../_shared/constants/base_urls.dart';

class ExpenseApprovalUrls {
  static String pendingApprovalListUrl(String companyId, int pageNumber, int itemsPerPage) {
    var url = '${BaseUrls.hrUrlV2()}/companies/$companyId/finance/expense/approvals';
    url += "?type=pending&page=$pageNumber&perPage=$itemsPerPage";
    return url;
  }

  static String approveUrl(String companyId) {
    return "${BaseUrls.hrUrlV2()}/companies/$companyId/easyapproval/approve";
  }

  static String rejectUrl(String companyId) {
    return "${BaseUrls.hrUrlV2()}/companies/$companyId/easyapproval/reject";
  }
}
