import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/my_portal/services/my_portal_performance_level_calculator.dart';

void main() {
  var performanceLevelCalculator = MyPortalPerformanceLevelCalculator();

  test('performance is bad if it is less than 70', () async {
    expect(performanceLevelCalculator.isPerformanceBad(0), true);
    expect(performanceLevelCalculator.isPerformanceBad(20), true);
    expect(performanceLevelCalculator.isPerformanceBad(40), true);
    expect(performanceLevelCalculator.isPerformanceBad(60), true);
    expect(performanceLevelCalculator.isPerformanceBad(69), true);

    expect(performanceLevelCalculator.isPerformanceBad(70), false);
    expect(performanceLevelCalculator.isPerformanceBad(100), false);
    expect(performanceLevelCalculator.isPerformanceBad(23470), false);
  });

  test('performance is average if it is equal to or more than 70 and less than 80', () async {
    expect(performanceLevelCalculator.isPerformanceAverage(0), false);
    expect(performanceLevelCalculator.isPerformanceAverage(20), false);
    expect(performanceLevelCalculator.isPerformanceAverage(40), false);
    expect(performanceLevelCalculator.isPerformanceAverage(60), false);
    expect(performanceLevelCalculator.isPerformanceAverage(69), false);

    expect(performanceLevelCalculator.isPerformanceAverage(70), true);
    expect(performanceLevelCalculator.isPerformanceAverage(75), true);
    expect(performanceLevelCalculator.isPerformanceAverage(79), true);

    expect(performanceLevelCalculator.isPerformanceAverage(80), false);
    expect(performanceLevelCalculator.isPerformanceAverage(100), false);
    expect(performanceLevelCalculator.isPerformanceAverage(23470), false);
  });

  test('performance is good if it is equal to or more than 80', () async {
    expect(performanceLevelCalculator.isPerformanceGood(0), false);
    expect(performanceLevelCalculator.isPerformanceGood(20), false);
    expect(performanceLevelCalculator.isPerformanceGood(40), false);
    expect(performanceLevelCalculator.isPerformanceGood(60), false);
    expect(performanceLevelCalculator.isPerformanceGood(70), false);
    expect(performanceLevelCalculator.isPerformanceGood(79), false);

    expect(performanceLevelCalculator.isPerformanceGood(80), true);
    expect(performanceLevelCalculator.isPerformanceGood(90), true);
    expect(performanceLevelCalculator.isPerformanceGood(100), true);
    expect(performanceLevelCalculator.isPerformanceGood(23470), true);
  });
}
