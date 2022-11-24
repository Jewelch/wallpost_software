import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_wp_core/performance/performance_calculator.dart';

void main() {
  test("cutoff values", () {
    var performanceCalculator = PerformanceCalculator();

    expect(performanceCalculator.lowPerformanceCutoff, 65);
    expect(performanceCalculator.mediumPerformanceCutoff, 79);
  });

  test("low performance", () {
    var performanceCalculator = PerformanceCalculator();

    expect(performanceCalculator.isLowPerformancePercent(-10), true);
    expect(performanceCalculator.isLowPerformancePercent(0), true);
    expect(performanceCalculator.isLowPerformancePercent(10), true);
    expect(performanceCalculator.isLowPerformancePercent(50), true);
    expect(performanceCalculator.isLowPerformancePercent(60), true);
    expect(performanceCalculator.isLowPerformancePercent(performanceCalculator.lowPerformanceCutoff), true);
    expect(performanceCalculator.isLowPerformancePercent(performanceCalculator.lowPerformanceCutoff + 1), false);
    expect(performanceCalculator.isLowPerformancePercent(9999), false);
  });

  test("medium performance", () {
    var performanceCalculator = PerformanceCalculator();

    expect(performanceCalculator.isMediumPerformancePercent(0), false);
    expect(performanceCalculator.isMediumPerformancePercent(performanceCalculator.lowPerformanceCutoff), false);
    expect(performanceCalculator.isMediumPerformancePercent(performanceCalculator.lowPerformanceCutoff + 1), true);
    expect(performanceCalculator.isMediumPerformancePercent(performanceCalculator.mediumPerformanceCutoff), true);
    expect(performanceCalculator.isMediumPerformancePercent(performanceCalculator.mediumPerformanceCutoff + 1), false);
    expect(performanceCalculator.isMediumPerformancePercent(9999), false);
  });

  test("high performance", () {
    var performanceCalculator = PerformanceCalculator();

    expect(performanceCalculator.isHighPerformancePercent(0), false);
    expect(performanceCalculator.isHighPerformancePercent(performanceCalculator.mediumPerformanceCutoff), false);
    expect(performanceCalculator.isHighPerformancePercent(performanceCalculator.mediumPerformanceCutoff + 1), true);
    expect(performanceCalculator.isHighPerformancePercent(9999), true);
  });
}
