import '../../../_shared/constants/base_urls.dart';

class LeaveApprovalUrls {
  static String approveUrl(String companyId) {
    return "${BaseUrls.hrUrlV2()}/companies/$companyId/easyapproval/approve";
  }

  static String rejectUrl(String companyId) {
    return "${BaseUrls.hrUrlV2()}/companies/$companyId/easyapproval/reject";
  }
}
