import '../../../_shared/constants/base_urls.dart';

class LeaveApprovalUrls {
  static String approveUrl(String companyId, String leaveId) {
    return "${BaseUrls.hrUrlV2()}/companies/$companyId/leaverequests/$leaveId/approve";
  }

  static String rejectUrl(String companyId, String leaveId) {
    return "${BaseUrls.hrUrlV2()}/companies/$companyId/leaverequests/$leaveId/reject";
  }
}
