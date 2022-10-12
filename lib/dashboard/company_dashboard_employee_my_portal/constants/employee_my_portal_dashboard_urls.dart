import '../../../../_shared/constants/base_urls.dart';

class EmployeeMyPortalDashboardUrls {
  static String employeeMyPortalDataUrl(String companyId) {
    return '${BaseUrls.hrUrlV3()}/companies/$companyId/get_dashboard_data';
  }
}
