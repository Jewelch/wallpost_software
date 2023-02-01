import 'package:flutter/foundation.dart';

import '../../../../_shared/exceptions/mapping_exception.dart';

class HourlySalesReport {
  final String totalRevenue;
  final String totalTickets;
  final List<HourlySalesItem> hourlySales;

  const HourlySalesReport({
    required this.totalRevenue,
    required this.totalTickets,
    required this.hourlySales,
  });

  factory HourlySalesReport.fromJson(Map<String, dynamic> json) {
    try {
      return HourlySalesReport(
        totalRevenue: json['summary']["total_tickets"],
        totalTickets: json['summary']["tickets"],
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

class HourlySalesItem {
  final String hour;
  final String ticketsCount;
  final String ticketsRevenue;

  const HourlySalesItem._({
    required this.hour,
    required this.ticketsCount,
    required this.ticketsRevenue,
  });

  factory HourlySalesItem.fromJson(Map<String, dynamic> json) => HourlySalesItem._(
        hour: json["hour"],
        ticketsCount: json["tickets"],
        ticketsRevenue: json["ticket_total"],
      );
}
