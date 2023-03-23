import 'package:flutter/foundation.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/hourly_sales/entities/hourly_sales_item.dart';

class HourlySalesReport {
  final String totalRevenue;
  final String totalTickets;
  final List<HourlySalesItem> hourlySales;

  const HourlySalesReport._({
    required this.totalRevenue,
    required this.totalTickets,
    required this.hourlySales,
  });

  factory HourlySalesReport.fromJson(Map<String, dynamic> json) {
    try {
      return HourlySalesReport._(
        totalRevenue: (json['summary']["total_tickets"] ?? 0).toString(),
        totalTickets: json['summary']["tickets"].toString(),
        hourlySales: json["data"] == null
            ? []
            : List<HourlySalesItem>.from(json["data"].map((x) => HourlySalesItem.fromJson(x))),
      );
    } catch (error, stackTrace) {
      debugPrint(stackTrace.toString());
      throw MappingException('Failed to cast ItemSalesDataModel response. Error message - $error');
    }
  }
}
