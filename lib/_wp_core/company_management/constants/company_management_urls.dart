// @dart=2.9

import 'package:wallpost/_shared/constants/base_urls.dart';

class CompanyManagementUrls {
  static String getCompaniesUrl() {
    return '${BaseUrls.hrUrlV2()}/performance/groupdashboard';
  }

  static String getCompanyDetailsUrl(String companyId) {
    return '${BaseUrls.baseUrlV2()}/companies/$companyId';
  }
}
