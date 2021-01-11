import 'package:wallpost/_shared/constants/base_urls.dart';
import 'package:wallpost/leave/entities/leave_list_filters.dart';

class LeaveUrls {
  static String leaveListUrl(String companyId, String employeeId,
      LeaveListFilters filters, int pageNumber, int itemsPerPage) {
    var url =
        '${BaseUrls.hrUrlV3()}/companies/$companyId/employees/$employeeId/leaverequests?'
        '&pageNumber=$pageNumber&itemsPerPage=$itemsPerPage';

    // if (filters.fromDateString != null)
    //   url += '&from_date=${filters.fromDateString}';
    // if (filters.toDateString != null) url += '&to_date=${filters.toDateString}';
    // if (filters.leaveType != null)
    //   url += '&leave_type_id=${filters.leaveType.id}';
    // if (filters.applicants != null) {
    //   filters.applicants
    //       .forEach((assignee) => url += '&employeeIds[]=${assignee.v1Id}');
    // }

    return url;
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

  static String airportsListUrl(String companyId, String employeeId,
      String search, int pageNumber, int itemsPerPage) {
    var url =
        '${BaseUrls.hrUrlV2()}/companies/$companyId/employees/$employeeId/airports?pageNumber=$pageNumber&itemsPerPage=$itemsPerPage';
    if (search != null || search.isNotEmpty) url += '?&search=$search';
    return url;
  }
}
