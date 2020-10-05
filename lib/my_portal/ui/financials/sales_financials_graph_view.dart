import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wallpost/my_portal/ui/financials/sales_financials_data_view.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class SalesFinancialsGraphView extends StatefulWidget {
  @override
  _SalesFinancialsGraphViewState createState() =>
      _SalesFinancialsGraphViewState();
}

class _SalesFinancialsGraphViewState extends State<SalesFinancialsGraphView> {
  bool isShowingMainData;
  final List<int> showIndexes = const [4];
  final List<FlSpot> allSpots = [
    FlSpot(1, 10),
    FlSpot(3, 25),
    FlSpot(9, 30),
    FlSpot(12, 50),
    FlSpot(15, 85),
  ];

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showIndexes,
        spots: allSpots,
        isCurved: true,
        curveSmoothness: 0,
         barWidth: 1,
        isStrokeCapRound: false,
        colors: [AppColors.chartLineColor],
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors: [
            AppColors.chartLineColor.withOpacity(0.1),
            AppColors.chartLineColor.withOpacity(0.0),
          ],
          gradientColorStops: [0.5, 1],
          gradientFrom: Offset(0, 0),
          gradientTo: Offset(0, 1),
        ),
      ),
    ];

    final LineChartBarData tooltipsOnBar = lineBarsData[0];

    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 40,
          child: Text('Sales Performance',
              style: TextStyle(color: Colors.grey, fontSize: 12)),
        ),
        SizedBox(
          width: double.infinity,
          height: 150,
          child: LineChart(LineChartData(
            showingTooltipIndicators: showIndexes.map((index) {
              return ShowingTooltipIndicators(index, [
                LineBarSpot(tooltipsOnBar, lineBarsData.indexOf(tooltipsOnBar),
                    tooltipsOnBar.spots[index]),
              ]);
            }).toList(),
            lineTouchData: LineTouchData(
              enabled: false,
              getTouchedSpotIndicator:
                  (LineChartBarData barData, List<int> spotIndexes) {
                return spotIndexes.map((index) {
                  return TouchedSpotIndicatorData(
                    FlLine(
                      color: Colors.transparent,
                    ),
                    FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 3,
                        color: AppColors.chartLineColor,
                        strokeWidth: 0,
                        strokeColor: Colors.transparent,
                      ),
                    ),
                  );
                }).toList();
              },
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: AppColors.chartLineColor,
                tooltipRoundedRadius: 50,
                getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                  return lineBarsSpot.map((lineBarSpot) {
                    return LineTooltipItem(
                      '${lineBarSpot.y.toInt()}% YTD 2018',
                      const TextStyle(fontSize: 10, color: Colors.white),
                    );
                  }).toList();
                },
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              horizontalInterval: 25,
              getDrawingHorizontalLine: (value) => FlLine(
                  color: AppColors.chartHorizontalLineColor, strokeWidth: 1),
            ),
            titlesData: FlTitlesData(
              bottomTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                textStyle: TextStyle(
                  color: AppColors.chartAxisTextColor,
                  fontSize: 10,
                ),
                margin: 5,
                getTitles: (value) {
                  switch (value.toInt()) {
                    case 0:
                      return 'Jan';
                    case 3:
                      return 'Feb';
                    case 6:
                      return 'Mar';
                    case 9:
                      return 'Apr';
                    case 12:
                      return 'May';
                    case 15:
                      return 'Jun';
                    case 18:
                      return 'Jul';
                    case 21:
                      return 'Aug';
                  }
                  return '';
                },
              ),
              leftTitles: SideTitles(
                showTitles: true,
                textStyle: TextStyle(
                  color: AppColors.chartAxisTextColor,
                  fontSize: 10,
                ),
                getTitles: (value) {
                  switch (value.toInt()) {
                    case 25:
                      return '25%';
                    case 50:
                      return '50%';
                    case 75:
                      return '75%';
                    case 100:
                      return '100%';
                  }
                  return '';
                },
                margin: 14,
                reservedSize: 28,
              ),
            ),
            borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.chartHorizontalLineColor,
                  ),
                  left: BorderSide(
                    color: Colors.transparent,
                  ),
                  right: BorderSide(
                    color: Colors.transparent,
                  ),
                  top: BorderSide(
                    color: AppColors.chartHorizontalLineColor,
                  ),
                )),
            minX: 0,
            maxX: 22,
            maxY: 100,
            minY: 0,
            lineBarsData: lineBarsData,
          )),
        ),
        SalesFinancialsDataView(
            financeDataName: 'Targeted Revenue', financeDataValue: '10,000'),
        SizedBox(height: 4),
        SalesFinancialsDataView(
            financeDataName: 'Actual Revenue', financeDataValue: '9,000'),
        SizedBox(height: 4),
        SalesFinancialsDataView(
            financeDataName: 'Bank & Cash', financeDataValue: '1,535,645'),
        SizedBox(height: 4),
        SalesFinancialsDataView(
            financeDataName: 'Profit & Loss',
            financeDataValue: '2,000,000,000'),
      ]),
    );
  }
}
