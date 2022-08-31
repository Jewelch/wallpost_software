import '../../../_shared/constants/base_urls.dart';

class LeaveApprovalListUrls {
  static String pendingApprovalListUrl(String companyId, int pageNumber, int itemsPerPage) {
    var url = '${BaseUrls.hrUrlV2()}/companies/$companyId/hr/leave/approvals?&page=$pageNumber&perPage=$itemsPerPage';
    url += "&type=pending";
    return url;
  }
}
