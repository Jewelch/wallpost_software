
class FinanceDashBoardUrls{
  static String getAttendanceDetailsUrl() {
    return 'https://hr.stagingapi.wallpostsoftware.com/api/v3/companies/28/finance/inner_page_data?year=2022&month=YTD';
  }

  static String getFinanceInnerPageDetails(String companyId, int? year, int? month) {
    var url = 'https://hr.stagingapi.wallpostsoftware.com/api/v3/companies/$companyId/finance/inner_page_data?';
    if (year != null) url += "year=$year";
    if (month != null) url += "&month=$month";

    return url;
  }
}