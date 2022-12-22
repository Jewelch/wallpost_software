import '../../_shared/constants/base_urls.dart';

class FinanceDashBoardUrls {
  static String getFinanceInnerPageDetails(String companyId, int? year, int? month) {
    var url = '${BaseUrls.hrUrlV3()}/companies/$companyId/finance/inner_page_data?';
    if (year != null) url += "year=$year";
    if (month != null) url += "&month=$month";
    if (month == null) url += "&month=YTD";

    return url;
  }
}
