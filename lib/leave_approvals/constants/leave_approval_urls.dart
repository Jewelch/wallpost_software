import 'package:wallpost/leave_approvals/entities/leave_approval_status.dart';

import '../../_shared/constants/base_urls.dart';

class LeaveApprovalUrls {
  static String leaveApprovalListUrl(
    String companyId,
    LeaveApprovalStatus approvalStatus,
    int pageNumber,
    int itemsPerPage,
  ) {
    var url = '${BaseUrls.hrUrlV2()}/companies/$companyId/hr/leave/approvals?&page=$pageNumber&perPage=$itemsPerPage';
    if (approvalStatus != LeaveApprovalStatus.all) url += "&type=${approvalStatus.stringValue()}";
    return url;
  }
}
