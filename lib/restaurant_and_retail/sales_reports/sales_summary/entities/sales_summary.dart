import 'package:flutter/foundation.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/sales_summary/entities/aggregated_sales_summary.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/sales_summary/entities/sales_summary_details.dart';

import '../../../../_shared/exceptions/mapping_exception.dart';

class SalesSummary {
  final AggregatedSalesSummary summary;
  final SalesSummaryDetails details;

  const SalesSummary._({required this.summary, required this.details});

  factory SalesSummary.fromJson(Map<String, dynamic> json) {
    try {
      return SalesSummary._(
        details: SalesSummaryDetails.fromJson(json['data']),
        summary: AggregatedSalesSummary.fromJson(json['summary']),
      );
    } catch (error, stackTrace) {
      debugPrint(stackTrace.toString());
      throw MappingException('Failed to cast $SalesSummary response. Error message - $error');
    }
  }
}
