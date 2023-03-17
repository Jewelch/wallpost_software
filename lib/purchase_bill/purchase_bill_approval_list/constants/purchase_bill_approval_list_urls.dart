
import '../../../_shared/constants/base_urls.dart';

class PurchaseBillApprovalListUrls{
  static String pendingApprovalListUrl(String companyId, int pageNumber, int itemsPerPage) {
    var url = '${BaseUrls.hrUrlV2()}/companies/$companyId/finance/bill/approvals?page=$pageNumber&perPage=$itemsPerPage';

   // var url ='https://hr.stagingapi.wallpostsoftware.com/api/v3/companies/$companyId/finance/bill/approvals?perPage=100';
   // url += "?type=pending&page=$pageNumber&perPage=$itemsPerPage";
    return url;
  }
}