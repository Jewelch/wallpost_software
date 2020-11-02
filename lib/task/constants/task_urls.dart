import 'package:wallpost/_shared/constants/base_urls.dart';

class TaskUrls {
  static String taskListCountUrl(String companyId, int year) {
    var url = '${BaseUrls.taskUrlV2()}/companies/$companyId/tasks/reports/counts';
    if (year != null) url += '&year=$year';
    return url;
  }

  static String taskCategoriesUrl(String companyId, String pageNumber, String itemsPerPage) {
    return '${BaseUrls.taskUrlV2()}/companies/$companyId/tasks/categories?&page=$pageNumber&per_page=$itemsPerPage';
  }
}
