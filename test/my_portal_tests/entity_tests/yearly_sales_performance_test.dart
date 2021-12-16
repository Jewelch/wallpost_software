// @dart=2.9

import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/my_portal/entities/sales_performance.dart';

import '../mocks.dart';

void main() {
  test('getting the monthly sales performance percentage', () async {
    var salesPerformance = SalesPerformance.fromJson(Mocks.salesPerformanceResponse);
    var currentYearPerformance = salesPerformance.currentYearPerformance;

    expect(currentYearPerformance.monthlySalesPercentages, [45, 300, 100, 0, 40, 133]);
  });
}
