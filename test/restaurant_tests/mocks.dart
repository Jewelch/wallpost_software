import 'package:mocktail/mocktail.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/aggregated_sales_data.dart';

class MockSalesData extends Mock implements AggregatedSalesData {}

class Mocks {
  static Map<String, dynamic> salesDataRandomResponse = {
    "total_sales": "21",
    "net_sales": "22",
    "cost_of_sales": "22",
    "gross_of_profit": 10,
  };

  static Map<String, dynamic> specificSalesDataResponse({
    required dynamic totalSales,
    required dynamic netSales,
    required dynamic costOfSales,
    required dynamic grossOfProfit,
  }) =>
      {
        "status": "success",
        "metadata": [],
        "data": {
          "total_sales": totalSales,
          "net_sales": netSales,
          "cost_of_sales": costOfSales,
          "gross_of_profit": grossOfProfit,
        }
      };

  static List<Map<String, dynamic>> salesBreakDownsData = [
    {
      "type": "21",
      "total_sales": 22,
    },
    {
      "type": "21",
      "total_sales": 22,
    },
    {
      "type": "21",
      "total_sales": 22,
    },
  ];
}
