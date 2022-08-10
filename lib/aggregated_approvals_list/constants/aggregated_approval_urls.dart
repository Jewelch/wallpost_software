import '../../_shared/constants/base_urls.dart';

class AggregatedApprovalUrls {
  static String getAggregatedApprovalsListUrl(String? companyId) {
    var url = '${BaseUrls.hrUrlV2()}/widget/approvals_aggregated_list';
    if (companyId != null) url += "?company_id=$companyId";
    return url;
  }
}
