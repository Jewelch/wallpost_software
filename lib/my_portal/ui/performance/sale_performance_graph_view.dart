import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/network_adapter/exceptions/api_exception.dart';
import 'package:wallpost/my_portal/entities/sales_performance.dart';
import 'package:wallpost/my_portal/services/my_portal_performance_level_calculator.dart';
import 'package:wallpost/my_portal/services/sales_performance_provider.dart';

class SalesPerormanceGraphView extends StatefulWidget {
  @override
  _SalesMyPortalPerormanceState createState() =>
      _SalesMyPortalPerormanceState();
}

class _SalesMyPortalPerormanceState extends State<SalesPerormanceGraphView> {
  SalesPerformance _salesPerformance;
  bool showError = false;
  double _performance = 0.75;

  @override
  void initState() {
    super.initState();
    _getSalesPerformance();
  }

  void _getSalesPerformance() async {

    setState(() {
      showError = false;
      _salesPerformance = null;
    });

    try {
      var performance =
          await SalesPerformanceProvider().getPerformance(DateTime.now().year);
      setState(() {
        _salesPerformance = performance;
      });
    } on APIException catch (_) {
      setState(() {
        showError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("performance////" + _salesPerformance.toString());
   // print("...currentyear../////////////////" +
    //    _salesPerformance.lastYearPerformance.actualSales);
    if (_salesPerformance != null) {
      return _buildSalesPerformanceGraphs();
    } else {
      return showError ? _buildErrorAndRetryView() : _buildProgressIndicator();
    }
  }

  Widget _buildSalesPerformanceGraphs() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            children: [
              CircularPercentIndicator(
                radius: 120.0,
                lineWidth: 4.0,
                animation: true,
                percent: _performance,
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: _getColorForPerformance(75),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '75%',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 24.0,
                          color: _getColorForPerformance(75)),
                    ),
                    Text(
                      "YTD 2018",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              _buildYearlyPerformanceBarGraphs(performancePercentage: 0)
            ],
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            children: <Widget>[
              _buildYearlyPerformanceBarGraphs(performancePercentage: 80),
              SizedBox(height: 12),
              _buildYearlyPerformanceBarGraphs(performancePercentage: 45),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildYearlyPerformanceBarGraphs({int performancePercentage}) {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Budgeted',
                style: TextStyle(fontSize: 12),
              ),
              Text(
                'Actual',
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '3.85M',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '1.49M',
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
        SizedBox(
          height: 4,
        ),
        performancePercentage > 0
            ? LinearPercentIndicator(
                animation: true,
                lineHeight: 4.0,
                animationDuration: 1000,
                percent: performancePercentage / 100,
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: _getColorForPerformance(performancePercentage))
            : SizedBox(height: 0),
        SizedBox(
          height: 4,
        ),
        performancePercentage > 0
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('2018',
                        style: TextStyle(
                            color:
                                _getColorForPerformance(performancePercentage),
                            fontSize: 12)),
                    Text(
                      '$performancePercentage%',
                      style: TextStyle(
                          color: _getColorForPerformance(performancePercentage),
                          fontSize: 12),
                    )
                  ],
                ),
              )
            : SizedBox(height: 0),
      ]),
    );
  }

  Color _getColorForPerformance(int performance) {
    var performanceLevelCalculator = MyPortalPerformanceLevelCalculator();
    if (performanceLevelCalculator.isPerformanceGood(performance)) {
      return AppColors.goodPerformanceColor;
    } else if (performanceLevelCalculator.isPerformanceAverage(performance)) {
      return AppColors.averagePerformanceColor;
    } else {
      return AppColors.badPerformanceColor;
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
                'Failed to performance\nTap Here To Retry',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              onPressed: () {
                setState(() {});
                _getSalesPerformance();
              },
            ),
          ],
        ),
      ),
    );
  }

}
