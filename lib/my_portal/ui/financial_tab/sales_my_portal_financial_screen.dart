import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wallpost/my_portal/ui/financial_tab/sales_my_portal_financial_data_list.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class SalesMyPortalFinancialScreen extends StatefulWidget {
  @override
  _SalesMyPortalFinancialScreenState createState() =>
      _SalesMyPortalFinancialScreenState();
}

class _SalesMyPortalFinancialScreenState
    extends State<SalesMyPortalFinancialScreen> {
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
        colors: [AppColors.chartLineColor],
        barWidth: 1,
        isStrokeCapRound: false,
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
          gradientFrom:  Offset(0, 0),
          gradientTo:  Offset(0, 1),
        ),
      ),
    ];

    final LineChartBarData tooltipsOnBar = lineBarsData[0];

    return Container(
      padding: EdgeInsets.only(top: 5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 40,
          child: Text(
            'Sales Revenue',
            style: TextStyle(color: AppColors.labelColor),
          ),
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
                show: true, drawHorizontalLine: true,
                 horizontalInterval: 25,
                 getDrawingHorizontalLine: (value) => FlLine(
                   color: AppColors.chartHorizontalLineColor,
                 strokeWidth: 1
                 ),),
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
                border:  Border(
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
        SalesMyPortalFinancialDataList(
            dataName: 'Targeted Revenue', dataValue: 10000),
        SalesMyPortalFinancialDataList(
            dataName: 'Actual Revenue', dataValue: 9000),
        SalesMyPortalFinancialDataList(
            dataName: 'Bank & Cash', dataValue: 1535645),
        SalesMyPortalFinancialDataList(
            dataName: 'Profit & Loss', dataValue: 2000000000),
      ]),
    );
  }
}
