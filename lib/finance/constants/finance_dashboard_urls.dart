class FinanceDashBoardUrls {
  static String getFinanceInnerPageDetails(String companyId, int? year, int? month) {
    var url = 'https://hr.stagingapi.wallpostsoftware.com/api/v3/companies/$companyId/finance/inner_page_data?';
    if (year != null) url += "year=$year";
    if (month != null) url += "&month=$month";
    if (month == null) url += "&month=YTD";

    return url;
  }
}
