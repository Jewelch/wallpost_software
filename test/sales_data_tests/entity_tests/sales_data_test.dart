import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_data.dart';

import '../mocks.dart';

void main() {
  test('SalesData model serialization succeeds when data is valid', () {
    final String totalSales = '12000';
    final String netSales = '4000';
    final String costOfSales = '2700';
    final int grossOfProfit = 40;

    final salesData = SalesData.fromJson(Mocks.specificSalesDataResponse(
      totalSales: totalSales,
      netSales: netSales,
      costOfSales: costOfSales,
      grossOfProfit: grossOfProfit,
    )['data']);

    expect(salesData.totalSales, totalSales);
    expect(salesData.netSales, netSales);
    expect(salesData.costOfSales, costOfSales);
    expect(salesData.grossOfProfit, '$grossOfProfit%');
  });

  test('SalesData model serialization throws a <MappingException> when data is invalid', () {
    try {
      SalesData.fromJson(
          Mocks.specificSalesDataResponse(totalSales: 12000, netSales: '4000', costOfSales: '2700', grossOfProfit: '40')['data']);

      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e, isA<MappingException>());
    }

    try {
      SalesData.fromJson(
          Mocks.specificSalesDataResponse(totalSales: '12000', netSales: 4000, costOfSales: '2700', grossOfProfit: '40')['data']);

      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e, isA<MappingException>());
    }

    try {
      SalesData.fromJson(
          Mocks.specificSalesDataResponse(totalSales: '12000', netSales: '4000', costOfSales: 2700, grossOfProfit: '40')['data']);

      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e, isA<MappingException>());
    }

    try {
      SalesData.fromJson(
          Mocks.specificSalesDataResponse(totalSales: '12000', netSales: '4000', costOfSales: '2700', grossOfProfit: 40)['data']);

      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e, isA<MappingException>());
    }
  });
}
