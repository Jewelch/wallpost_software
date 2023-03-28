import 'package:wallpost/restaurant_and_retail/sales_reports/hourly_sales/entities/hourly_sales_report.dart';

var hourlySalesReportSuccessfulResponse = {
  "summary": {
    "total_tickets": "10,000",
    "tickets": "5,990",
  },
  "data": [
    {
      "hour": "9 to 10 AM",
      "tickets": "8",
      "ticket_total": "2,550",
    },
    {
      "hour": "11 AM to 12 PM",
      "tickets": "18",
      "ticket_total": "3,000",
    },
    {
      "hour": "12 to 1 PM",
      "tickets": "3",
      "ticket_total": "750",
    },
    {
      "hour": "1 to 2 PM",
      "tickets": "2",
      "ticket_total": "1,050",
    },
  ]
};

HourlySalesReport getHourlySalesReport() {
  var report = HourlySalesReport.fromJson(hourlySalesReportSuccessfulResponse);
  return report;
}
