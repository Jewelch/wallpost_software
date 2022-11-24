import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wallpost/_wp_core/performance/performance_calculator.dart';

import '../../_shared/constants/app_colors.dart';

class PerformancePieChart extends StatelessWidget {
  final double size;
  final double value;
  final String valueText;
  final TextStyle valueTextStyle;

  final performanceCalculator = PerformanceCalculator();

  PerformancePieChart({
    required this.size,
    required this.value,
    required this.valueText,
    required this.valueTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Text(
                valueText,
                style: valueTextStyle.copyWith(
                  color: performanceCalculator.getColorForPerformance(value.toInt()),
                ),
              ),
            ),
          ),
          PieChart(
            PieChartData(
              sections: cutoffPerformanceSections(),
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: size / 2,
              startDegreeOffset: 270.0,
            ),
          ),
          PieChart(
            PieChartData(
              sections: actualPerformanceSections(),
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: size / 2,
              startDegreeOffset: 270.0,
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> cutoffPerformanceSections() {
    List<PieChartSectionData> pieChartDataList = [];
    pieChartDataList.add(_generatePieChartData(
      value: performanceCalculator.lowPerformanceCutoff.toDouble(),
      color: AppColors.red.withOpacity(0.5),
      radius: 3,
    ));
    pieChartDataList.add(_generatePieChartData(
      value: performanceCalculator.mediumPerformanceCutoff.toDouble(),
      color: AppColors.yellow.withOpacity(0.5),
      radius: 3,
    ));
    pieChartDataList.add(_generatePieChartData(
      value: 100 - performanceCalculator.mediumPerformanceCutoff.toDouble(),
      color: AppColors.green.withOpacity(0.5),
      radius: 3,
    ));
    return pieChartDataList;
  }

  List<PieChartSectionData> actualPerformanceSections() {
    List<PieChartSectionData> pieChartDataList = [
      _generatePieChartData(
        value: value,
        color: performanceCalculator.getColorForPerformance(value.toInt()),
        radius: 3,
      ),
      _generatePieChartData(
        value: 100 - value,
        color: Colors.transparent,
        radius: 3,
      )
    ];
    return pieChartDataList;
  }

  PieChartSectionData _generatePieChartData({required double value, required Color color, required double radius}) {
    return PieChartSectionData(
      value: value,
      color: color,
      radius: radius,
      title: '',
    );
  }
}
