import 'package:mocktail/mocktail.dart';
import 'package:random_string/random_string.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_data.dart';

class MockSalesData extends Mock implements SalesData {}

class Mocks {
  static var loginResponse = {
    "full_name": "Full User Name",
    "profile_image": "www.imageUrl.com",
    "refresh_token": "refToken",
    "token": "accessToken",
    "token_expiry": DateTime.now().millisecondsSinceEpoch + 100000,
    "user_id": "09TZ3NLA195FpWJ",
    "username": "someUserName"
  };

  static Map<String, dynamic> get userMapWithInactiveSession {
    Map<String, dynamic> map = Map.from(loginResponse);
    map['token_expiry'] = 123;
    return map;
  }

  static Map<String, dynamic> salesDataRandomResponse = {
    "status": "success",
    "metadata": [],
    "data": {
      "total_sales": randomNumeric(3),
      "net_sales": randomNumeric(3),
      "cost_of_sales": randomNumeric(3),
      "gross_of_profit": randomNumeric(2),
    }
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
}
