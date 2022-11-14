import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/aggregated_sales_data.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_break_down_item.dart';

class MockSalesData extends Mock implements AggregatedSalesData {}

class Mocks {
  static List<Color> colors = [
    AppColors.green,
    AppColors.yellow,
    AppColors.red,
  ];
  static Map<String, dynamic> salesDataRandomResponse = {
    "total_sales": "0",
    "net_sales": "22",
    "cost_sales": "22",
    "gross_profit_percentage": 10,
  };
  static Map<String, dynamic> salesDataRandomResponseNegativeProfit = {
    "total_sales": "0",
    "net_sales": "22",
    "cost_sales": "22",
    "gross_profit_percentage": -10,
  };
  static Map<String, dynamic> salesDataRandomResponseNull = {
    "total_sales": null,
    "net_sales": null,
    "cost_sales": null,
    "gross_profit_percentage": null,
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

  static List<SalesBreakDownItem> salesBreakDownsItems = [
    SalesBreakDownItem.fromJson(
      {
        "type": "10",
        "total_sales": 10,
      },
    ),
    SalesBreakDownItem.fromJson(
      {
        "type": "50",
        "total_sales": 50,
      },
    ),
    SalesBreakDownItem.fromJson(
      {
        "type": "20",
        "total_sales": 20,
      },
    ),
  ];
}
