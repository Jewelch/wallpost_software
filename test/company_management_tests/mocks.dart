import 'package:random_string/random_string.dart';

class Mocks {
  static List<Map<String, dynamic>> companiesListResponse = [
    {
      "actual_revenue": randomBetween(1000, 5000),
      "actual_revenue_display": randomString(10),
      "alerts": randomBetween(1000, 5000),
      "approvals": randomBetween(1000, 5000),
      "budgeted_revenue": randomBetween(1000, 5000),
      "budgeted_revenue_display": randomString(10),
      "commercial_name": randomString(10),
      "companyId": randomBetween(1000, 5000),
      "currency": randomString(10),
      "hexString": randomString(10),
      "name": randomString(10),
      "notifications": randomBetween(1000, 5000),
      "overall_revenue": randomBetween(1000, 5000),
      "show_revenue": 1,
      "ytd_performance": randomString(10),
    },
    {
      "actual_revenue": randomBetween(1000, 5000),
      "actual_revenue_display": randomString(10),
      "alerts": randomBetween(1000, 5000),
      "approvals": randomBetween(1000, 5000),
      "budgeted_revenue": randomBetween(1000, 5000),
      "budgeted_revenue_display": randomString(10),
      "commercial_name": randomString(10),
      "companyId": randomBetween(1000, 5000),
      "currency": randomString(10),
      "hexString": randomString(10),
      "name": randomString(10),
      "notifications": randomBetween(1000, 5000),
      "overall_revenue": randomBetween(1000, 5000),
      "show_revenue": 0,
      "ytd_performance": randomString(10),
    },
  ];
}
