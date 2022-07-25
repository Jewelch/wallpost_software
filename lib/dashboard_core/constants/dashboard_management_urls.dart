import 'package:wallpost/_shared/constants/base_urls.dart';

class DashboardManagementUrls {
  static String getActionAlertsUrl() {
    return '${BaseUrls.hrUrlV3()}/companies/2/get_actions_alerts_data';
  }

  static String getCompanyDashboardUrl() {
    return '${BaseUrls.baseUrlV2()}/companies/2/get_actions_alerts_data';
  }

  static String getApprovalsUrl(String? companyId, int pageNumber, int itemsPerPage) {
    var url = '${BaseUrls.hrUrlV2()}/widget/actions?page=$pageNumber&perPage=$itemsPerPage';
    if (companyId != null) url += "&company_id=$companyId";
    return url;
  }

  static String getApprovalAggregatedListUrl() {
    return '${BaseUrls.hrUrlV2()}/widget/approvals_aggregated_list';
  }
}
