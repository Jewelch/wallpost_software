import 'package:mocktail/mocktail.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/aggregated_sales_data.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_break_down_item.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/entities/item_sales_model.dart';

class MockSalesData extends Mock implements AggregatedSalesData {}

class MockItemSalesData extends Mock implements ItemSalesReport {}

class Mocks {
  static Map<String, dynamic> salesDataRandomResponse = {
    "total_sales": "0",
    "net_sales": "22",
    "cost_sales": "22",
    "gross_profit_percentage": 10,
  };

  static Map<String, dynamic> specificSalesDataResponse({
    required dynamic totalSales,
    required dynamic netSales,
    required dynamic costOfSales,
    required dynamic grossOfProfit,
  }) =>
      {
        "discount": "3,095",
        "cost_sales": costOfSales,
        "total_sales": totalSales,
        "net_sales": netSales,
        "gross_profit": "54,407",
        "gross_profit_percentage": grossOfProfit,
      };

  static List<Map<String, dynamic>> salesBreakDownsData = [
    {
      "type": "21",
      "total_sales": 22,
      "total_sales_num_format": "22",
    },
    {
      "type": "21",
      "total_sales": 22,
      "total_sales_num_format": "22",
    },
    {
      "type": "21",
      "total_sales": 22,
      "total_sales_num_format": "22",
    },
  ];

  static List<SalesBreakDownItem> salesBreakDownsItems = [
    SalesBreakDownItem.fromJson(
      {
        "type": "10",
        "total_sales": 10,
        "total_sales_num_format": "10,00",
      },
    ),
    SalesBreakDownItem.fromJson(
      {
        "type": "50",
        "total_sales": 50,
        "total_sales_num_format": "50,00",
      },
    ),
    SalesBreakDownItem.fromJson(
      {
        "type": "20",
        "total_sales": 20,
        "total_sales_num_format": "20,00",
      },
    ),
  ];

  static List<Map<String, dynamic>> itemSalesBreakdownListMock = [
    {
      "categoryId": 1,
      "categoryName": "Soda",
      "totalQuantity": 13,
      "totalRevenue": 61,
      "totalRevenueToDisplay": "61",
      "items": [
        {"itemId": 7, "itemName": "Stewart's", "qty": 2, "revenue": 12, "revenueToDisplay": "12"},
        {"itemId": 6, "itemName": "Mirinda", "qty": 5, "revenue": 25, "revenueToDisplay": "25"},
        {"itemId": 5, "itemName": "Fanta", "qty": 2, "revenue": 10, "revenueToDisplay": "10"},
        {"itemId": 1, "itemName": "Coke", "qty": 2, "revenue": 0, "revenueToDisplay": "0"},
        {"itemId": 8, "itemName": "Mtn Dew Live Wire", "qty": 2, "revenue": 14, "revenueToDisplay": "14"}
      ]
    },
    {
      "categoryId": 2,
      "categoryName": "Salads",
      "totalQuantity": 9,
      "totalRevenue": 114,
      "totalRevenueToDisplay": "114",
      "items": [
        {"itemId": 2, "itemName": "Cesar Salad with chicken ", "qty": 4, "revenue": 4, "revenueToDisplay": "4"},
        {"itemId": 11, "itemName": "Pasta Salad", "qty": 3, "revenue": 54, "revenueToDisplay": "54"},
        {"itemId": 12, "itemName": "Creamy Vegan Pasta Salad", "qty": 2, "revenue": 56, "revenueToDisplay": "56"}
      ]
    },
  ];

  static Map<String, dynamic> specificItemSalesResponse({
    required dynamic totalRevenue,
    required dynamic totalCategories,
    required dynamic totalItemsInAllCategories,
    required dynamic totalOfAllItemsQuantities,
    required dynamic breakdown,
    required bool isExpanded,
  }) =>
      {
        "totalRevenue": totalRevenue,
        "totalCategories": totalCategories,
        "totalItemsInAllCategories": totalItemsInAllCategories,
        "totalOfAllItemsQuantities": totalOfAllItemsQuantities,
        "breakdown": breakdown,
        "isExpanded": isExpanded,
      };
}
