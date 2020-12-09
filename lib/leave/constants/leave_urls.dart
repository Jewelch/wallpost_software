import 'package:wallpost/_shared/constants/base_urls.dart';

class LeaveUrls {
  static String leaveListUrl(String companyId, String employeeId, String pageNumber, String itemsPerPage) {
    return '${BaseUrls.hrUrlV3()}/companies/$companyId/employees/$employeeId/leaverequests?'
        '&pageNumber=$pageNumber&itemsPerPage=$itemsPerPage';
  }

  static String leaveTypesUrl(String companyId, String employeeId) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/employees/$employeeId/leavetypes';
  }
}
