import 'package:wallpost/_shared/constants/base_urls.dart';

class CompanyManagementUrls {
  static String getCompaniesUrl() {
    return '${BaseUrls.hrUrlV2()}/performance/groupdashboard';
  }

  static String getEmployeeDetailsUrl(String companyId) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId';
  }
}
