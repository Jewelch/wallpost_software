import '../../../_shared/constants/base_urls.dart';

class PurchaseBillDetailUrls {
  static String getPurchaseBillDetailUrl(String companyId, String billId) {
    return '${BaseUrls.hrUrlV2()}/companies/$companyId/finance/bill/approvals/$billId';
  }
}
