import 'package:wallpost/_shared/constants/base_urls.dart';
import 'package:wallpost/task/entities/task_list_filters.dart';

class TaskUrls {
  static String taskListCountUrl(String companyId, int year) {
    var url = '${BaseUrls.taskUrlV2()}/companies/$companyId/tasks/reports/counts';
    if (year != null) url += '?year=$year';
    return url;
  }

  static String taskCategoriesUrl(String companyId, int pageNumber, int itemsPerPage, String searchText) {
    var url = '${BaseUrls.taskUrlV2()}/companies/$companyId/tasks/categories?&page=$pageNumber&per_page=$itemsPerPage';
    if (searchText != null && searchText.isNotEmpty) url += '&search=$searchText';
    return url;
  }

  static String departmentsUrl(String companyId, int pageNumber, int itemsPerPage, String searchText) {
    var url = '${BaseUrls.taskUrlV2()}/companies/$companyId/departments?&page=$pageNumber&per_page=$itemsPerPage';
    if (searchText != null && searchText.isNotEmpty) url += '&search=$searchText';
    return url;
  }

  static String assigneesUrl(String companyId, int pageNumber, int itemsPerPage, String searchText) {
    var url = '${BaseUrls.taskUrlV2()}/companies/$companyId/employees?&page=$pageNumber&per_page=$itemsPerPage';
    if (searchText != null && searchText.isNotEmpty) url += '&search=$searchText';
    return url;
  }

  static String subordinatesUrl(String companyId, int pageNumber, int itemsPerPage, String searchText) {
    var url =
        '${BaseUrls.taskUrlV2()}/companies/$companyId/tasks/getSubOrdinates?&page=$pageNumber&per_page=$itemsPerPage';
    if (searchText != null && searchText.isNotEmpty) url += '&search=$searchText';
    return url;
  }

  static String taskListUrl(
    String companyId,
    TaskListFilters filters,
    int pageNumber,
    int itemsPerPage,
  ) {
    var url = '${BaseUrls.taskUrlV2()}/companies/$companyId/tasks';
    url += '?&scope=${filters.scope}';
    url += '&status=${filters.status}';
    if (filters.searchText != null) url += '&search=${filters.searchText}';
    if (filters.year != null) url += '&year=${filters.year}';
    filters.assignees.forEach((assignee) => url += '&assignees[]=${assignee.v1Id}');
    filters.departments.forEach((department) => url += '&department[]=${department.id}');
    filters.categories.forEach((category) => url += '&categories[]=${category.id}');
    url += '&page=$pageNumber';
    url += '&per_page=$itemsPerPage';
    return url;
  }

  static String getTimeZonesUrl(String companyId) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/timezones/getTimezones?';
  }

  static String createTaskUrl(String companyId) {
    return '${BaseUrls.taskUrlV2()}/companies/$companyId/tasks?';
  }
}
