import 'package:wallpost/_shared/constants/base_urls.dart';

class CompanyManagementUrls {
  static String getCompaniesUrl(String pageNumber, String itemsPerPage) {
    return '${BaseUrls.hrUrlV2}/performance/groupdashboard?&pageNumber=$pageNumber&itemsPerPage=$itemsPerPage';
  }
}
