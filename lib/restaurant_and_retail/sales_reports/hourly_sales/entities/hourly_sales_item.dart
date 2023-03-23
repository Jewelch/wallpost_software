import 'package:flutter/foundation.dart';

import '../../../../_shared/exceptions/mapping_exception.dart';

class HourlySalesItem {
  final String hour;
  final String ticketsCount;
  final String ticketsRevenue;

  const HourlySalesItem._({
    required this.hour,
    required this.ticketsCount,
    required this.ticketsRevenue,
  });

  factory HourlySalesItem.fromJson(Map<String, dynamic> json) {
    try {
      return HourlySalesItem._(
        hour: json["hour"],
        ticketsCount: json["tickets"],
        ticketsRevenue: json["ticket_total"],
      );
    } catch (error, stackTrace) {
      debugPrint(stackTrace.toString());
      throw MappingException('Failed to cast HourlySalesItem response. Error message - $error');
    }
  }
}
