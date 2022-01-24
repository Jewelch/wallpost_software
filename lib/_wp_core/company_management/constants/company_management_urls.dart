import 'package:wallpost/_shared/constants/base_urls.dart';

class CompanyManagementUrls {
  static String getCompaniesUrl() {
    return '${BaseUrls.hrUrlV3()}/groupdashboard';
  }

  static String getCompanyDetailsUrl(String companyId) {
    return '${BaseUrls.baseUrlV2()}/companies/$companyId';
  }
}

