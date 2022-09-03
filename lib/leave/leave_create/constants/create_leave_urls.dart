import '../../../_shared/constants/base_urls.dart';

class CreateLeaveUrls {
  static String leaveSpecsUrl(String companyId, String employeeId) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/employees/$employeeId/leavetypes';
  }

  static String leaveDateCheckUrl(
      String companyId, String employeeId, String leaveType, String fromDate, String toDate) {
    return 'https://hr.api.wallpostsoftware.com/api/v2/companies/$companyId/employees/$employeeId/leavetypes/$leaveType/from/$fromDate/to/$toDate/child_age/0';
  }

  static String airportsListUrl(String companyId, String employeeId, String? search, int pageNumber, int itemsPerPage) {
    var url =
        '${BaseUrls.hrUrlV2()}/companies/$companyId/employees/$employeeId/airports?pageNumber=$pageNumber&itemsPerPage=$itemsPerPage';
    if (search != null && search.isNotEmpty) url += '?&search=$search';
    return url;
  }

  static String createLeaveUrl(String companyId, String employeeId) {
    return 'https://hr.api.wallpostsoftware.com/api/v2/companies/$companyId/employees/$employeeId/leaverequests';
  }
}
