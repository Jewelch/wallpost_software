import 'package:wallpost/_shared/constants/base_urls.dart';

class LeaveUrls {
  static String leaveListUrl(String companyId, String employeeId,
      String pageNumber, String itemsPerPage) {
    return '${BaseUrls.hrUrlV3()}/companies/$companyId/employees/$employeeId/leaverequests?'
        '&pageNumber=$pageNumber&itemsPerPage=$itemsPerPage';
  }

  static String leaveTypesUrl(String companyId, String employeeId) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/employees/$employeeId/leavetypes';
  }

  static String assigneesUrl(
      String companyId, int pageNumber, int itemsPerPage, String searchText) {
    var url =
        '${BaseUrls.taskUrlV2()}/companies/$companyId/employees?&page=$pageNumber&per_page=$itemsPerPage';
    if (searchText != null) url += '&search=$searchText';
    return url;
  }

  static String subordinatesUrl(
      String companyId, int pageNumber, int itemsPerPage, String searchText) {
    var url =
        '${BaseUrls.taskUrlV2()}/companies/$companyId/tasks/getSubOrdinates?&page=$pageNumber&per_page=$itemsPerPage';
    if (searchText != null) url += '&search=$searchText';
    return url;
  }
}
