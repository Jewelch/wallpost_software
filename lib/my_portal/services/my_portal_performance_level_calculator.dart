// @dart=2.9

class MyPortalPerformanceLevelCalculator {
  bool isPerformanceBad(int performance) {
    return performance < 70;
  }

  bool isPerformanceAverage(int performance) {
    return performance >= 70 && performance < 80;
  }

  bool isPerformanceGood(int performance) {
    return isPerformanceBad(performance) == false && isPerformanceAverage(performance) == false;
  }
}
