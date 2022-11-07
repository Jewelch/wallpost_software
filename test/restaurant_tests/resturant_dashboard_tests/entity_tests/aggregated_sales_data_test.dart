import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/aggregated_sales_data.dart';

import '../../mocks.dart';

void main() {
  test('SalesData model serialization succeeds when data is valid', () {
    final String totalSales = '12000';
    final String netSales = '4000';
    final String costOfSales = '2700';
    final int grossOfProfit = 40;

    final salesData = AggregatedSalesData.fromJson(Mocks.specificSalesDataResponse(
      totalSales: totalSales,
      netSales: netSales,
      costOfSales: costOfSales,
      grossOfProfit: grossOfProfit,
    ));

    expect(salesData.totalSales, totalSales);
    expect(salesData.netSales, netSales);
    expect(salesData.costOfSales, costOfSales);
    expect(salesData.grossOfProfit, '$grossOfProfit');
  });

  test('SalesData model serialization throws a <MappingException> when data is invalid', () {
    try {
      AggregatedSalesData.fromJson(Mocks.specificSalesDataResponse(
        totalSales: 12000,
        netSales: '4000',
        costOfSales: '2700',
        grossOfProfit: 'sdfdsf40d',
      ));

      fail('failed to throw the mapping exception');
    } catch (e) {
      expect(e, isA<MappingException>());
    }

    try {
      AggregatedSalesData.fromJson(Mocks.specificSalesDataResponse(
        totalSales: '12000',
        netSales: 4000,
        costOfSales: '2700',
        grossOfProfit: '4332dsda0',
      ));

      fail('failed to throw mapping exception');
    } catch (e) {
      expect(e, isA<MappingException>());
    }

    try {
      AggregatedSalesData.fromJson(Mocks.specificSalesDataResponse(
        totalSales: '12000',
        netSales: '4000',
        costOfSales: 2700,
        grossOfProfit: '40sad',
      ));

      fail('failed to throw mapping exception');
    } catch (e) {
      expect(e, isA<MappingException>());
    }
  });
}
