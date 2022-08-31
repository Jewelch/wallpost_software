import 'package:wallpost/_shared/constants/base_urls.dart';

class LeaveDetailUrls {
  static String leaveDetailUrl(String companyId, String leaveId) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/leaverequests/$leaveId';
  }
}
