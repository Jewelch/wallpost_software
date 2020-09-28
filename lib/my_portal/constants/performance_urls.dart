import 'package:wallpost/_shared/constants/base_urls.dart';

class PerformanceUrls {
  static String salesPerformanceUrl(String companyId, String year) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/sales/performance?&year=$year';
  }

  static String employeePerformanceUrl(String companyId, String year) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/performance/my?&year=$year';
  }
}
