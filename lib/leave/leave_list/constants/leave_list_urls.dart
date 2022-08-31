import 'package:wallpost/_shared/constants/base_urls.dart';

import '../entities/leave_list_status_filter.dart';

class LeaveListUrls {
  static String leaveListUrl(
      String companyId, String employeeId, LeaveListStatusFilter status, int pageNumber, int itemsPerPage) {
    var url = '${BaseUrls.hrUrlV3()}/companies/$companyId/employees/$employeeId/leaverequests?'
        '&page=$pageNumber&perPage=$itemsPerPage';
    url += "&type=${status.toRawString()}";
    return url;
  }
}
