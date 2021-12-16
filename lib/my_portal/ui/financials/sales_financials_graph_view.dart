import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_wp_core/wpapi/exceptions/api_exception.dart';
import 'package:wallpost/my_portal/entities/sales_performance.dart';
import 'package:wallpost/my_portal/services/sales_performance_provider.dart';

class SalesFinancialsGraphView extends StatefulWidget {
  @override
  _SalesFinancialsGraphViewState createState() => _SalesFinancialsGraphViewState();
}

//TODO: Add year filter
class _SalesFinancialsGraphViewState extends State<SalesFinancialsGraphView> {
  bool showError = false;
  SalesPerformance _salesPerformance;
  var _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _getSalesFinancialsGraph();
  }

  void _getSalesFinancialsGraph() async {
    setState(() {
      showError = false;
      _salesPerformance = null;
    });

    try {
      var performance = await SalesPerformanceProvider().getPerformance(_selectedYear);
      setState(() => _salesPerformance = performance);
    } on APIException catch (_) {
      setState(() => showError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_salesPerformance != null) {
      return _buildSalesFinancialsGraphView();
    } else {
      return showError ? _buildErrorAndRetryView() : _buildProgressIndicator();
    }
  }

  Widget _buildSalesFinancialsGraphView() {
    final List<double> yValues =
        _salesPerformance.currentYearPerformance.monthlySalesPercentages.map((i) => i.toDouble()).toList();
    final int yValuesLength = yValues.length;
    final List<int> showIndexes = [yValuesLength - 1];
    List<FlSpot> allSpots = yValues.asMap().entries.map((e) {
      return FlSpot((e.key.toDouble() * 2), e.value);
    }).toList();
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
          gradientColorStops: [0.4, 1],
          gradientFrom: Offset(0, 0),
          gradientTo: Offset(0, 1),
        ),
      ),
    ];

    final LineChartBarData tooltipsOnBar = lineBarsData[0];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 36,
            child: Text('Monthly Sales', style: TextStyle(color: Colors.grey, fontSize: 1)),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 8),
            height: 200,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 22,
                maxY: 100,
                minY: 0,
                lineBarsData: lineBarsData,
                showingTooltipIndicators: showIndexes.map((index) {
                  return ShowingTooltipIndicators([
                    LineBarSpot(tooltipsOnBar, lineBarsData.indexOf(tooltipsOnBar), tooltipsOnBar.spots[index]),
                  ]);
                }).toList(),
                lineTouchData: LineTouchData(
                  enabled: false,
                  getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                    return spotIndexes.map((index) {
                      return TouchedSpotIndicatorData(
                        FlLine(color: Colors.transparent),
                        FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                            radius: 4,
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
                    tooltipPadding: EdgeInsets.all(4),
                    tooltipMargin: 12,
                    tooltipRoundedRadius: 40,
                    getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                      return lineBarsSpot.map((lineBarSpot) {
                        return LineTooltipItem(
                          '${lineBarSpot.y.toInt()}% \nYTD $_selectedYear',
                          TextStyle(fontSize: 8, color: Colors.white),
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: AppColors.chartGridLineColor, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 24,
                    margin: 4,
                    // textStyle: TextStyle(color: Colors.grey, fontSize: 8),
                    getTitles: (value) => _getMonthString(value.toInt()),
                  ),
                  leftTitles: SideTitles(
                    showTitles: true,
                    margin: 8,
                    reservedSize: 20,
                    // textStyle: TextStyle(color: Colors.grey, fontSize: 8),
                    getTitles: (value) {
                      switch (value.toInt()) {
                        case 25:
                        case 50:
                        case 75:
                        case 100:
                          return '${value.toInt()}%';
                        default:
                          return '';
                      }
                    },
                  ),
                ),
                borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: AppColors.chartGridLineColor),
                      left: BorderSide(color: Colors.transparent),
                      right: BorderSide(color: Colors.transparent),
                      top: BorderSide(color: AppColors.chartGridLineColor),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthString(int value) {
    switch (value) {
      case 0:
        return 'Jan';
      case 2:
        return 'Feb';
      case 4:
        return 'Mar';
      case 6:
        return 'Apr';
      case 8:
        return 'May';
      case 10:
        return 'Jun';
      case 12:
        return 'Jul';
      case 14:
        return 'Aug';
      case 16:
        return 'Sep';
      case 18:
        return 'Oct';
      case 20:
        return 'Nov';
      case 22:
        return 'Dec';
      default:
        return '';
    }
  }

  Widget _buildProgressIndicator() {
    return Container(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 30, height: 30, child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildErrorAndRetryView() {
    return Container(
      height: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              child: Text(
                'Failed to load performance\nTap Here To Retry',
                textAlign: TextAlign.center,
                style: TextStyles.failureMessageTextStyle,
              ),
              onPressed: () {
                setState(() {});
                _getSalesFinancialsGraph();
              },
            ),
          ],
        ),
      ),
    );
  }
}
