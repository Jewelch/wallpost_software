import '../../../_shared/constants/base_urls.dart';

class PurchaseBillApprovalListUrls {
  static String pendingApprovalListUrl(String companyId, int pageNumber, int itemsPerPage) {
    var url =
        '${BaseUrls.hrUrlV3()}/companies/$companyId/finance/bill/approvals?page=$pageNumber&perPage=$itemsPerPage';
    return url;
  }
}
