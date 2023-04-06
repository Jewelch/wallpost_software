import '../../../_shared/constants/base_urls.dart';

class PurchaseBillDetailUrls {
  static String getPurchaseBillDetailUrl(String companyId, String billId) {
    //TODO
    return 'https://hr.stagingapi.wallpostsoftware.com/api/v3/companies/$companyId/finance/bill/approvals/$billId';
   // return '${BaseUrls.hrUrlV2()}/companies/$companyId/finance/bill/approvals/$billId';
  }
}
