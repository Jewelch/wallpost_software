import 'dart:ui';

import 'package:wallpost/_shared/constants/app_colors.dart';

class PerformanceCalculator {
  final _lowPerformanceCutoff = 65;
  final _mediumPerformanceCutoff = 79;

  bool isLowPerformancePercent(int performancePercent) {
    return performancePercent <= _lowPerformanceCutoff;
  }

  bool isMediumPerformancePercent(int performancePercent) {
    return performancePercent > _lowPerformanceCutoff && performancePercent <= _mediumPerformanceCutoff;
  }

  bool isHighPerformancePercent(int performancePercent) {
    return !isLowPerformancePercent(performancePercent) && !isMediumPerformancePercent(performancePercent);
  }

  Color getColorForPerformance(int performancePercent) {
    if (isLowPerformancePercent(performancePercent)) {
      return AppColors.red;
    } else if (isMediumPerformancePercent(performancePercent)) {
      return AppColors.yellow;
    } else {
      return AppColors.green;
    }
  }

  int get lowPerformanceCutoff => _lowPerformanceCutoff;

  int get mediumPerformanceCutoff => _mediumPerformanceCutoff;
}
