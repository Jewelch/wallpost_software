import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/network_adapter/exceptions/api_exception.dart';
import 'package:wallpost/my_portal/entities/employee_performance.dart';
import 'package:wallpost/my_portal/services/employee_performance_provider.dart';
import 'package:wallpost/my_portal/services/my_portal_performance_level_calculator.dart';

class EmployeePerformanceGraphView extends StatefulWidget {
  @override
  _EmployeePerformanceGraphViewState createState() => _EmployeePerformanceGraphViewState();
}

class _EmployeePerformanceGraphViewState extends State<EmployeePerformanceGraphView> {
  EmployeePerformance _employeePerformance;
  bool showError=false;

  @override
  void initState() {
    super.initState();
      _getEmployeePerformance();
  }

  void _getEmployeePerformance() async {
    setState(() {
      showError = false;
      _employeePerformance = null;
    });

    try {
      var performance = await EmployeePerformanceProvider().getPerformance(DateTime.now().year);
      setState(() => _employeePerformance = performance);
    } on APIException catch (_) {
      setState(() => showError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_employeePerformance != null) {
      return _buildEmployeePerformanceGraphs();
    } else {
      return showError ? _buildErrorAndRetryView() : _buildProgressIndicator();
    }
  }

  Widget _buildEmployeePerformanceGraphs() {
    return Row(
      children: [
        Container(
          height: 150,
          child: CircularPercentIndicator(
            radius: 140.0,
            lineWidth: 4.0,
            animation: true,
            percent: _employeePerformance.overallYearlyPerformancePercent / 100,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: _getColorForPerformance(_employeePerformance.overallYearlyPerformancePercent),
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${_employeePerformance.overallYearlyPerformancePercent}',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 24.0,
                    color: _getColorForPerformance(_employeePerformance.overallYearlyPerformancePercent),
                  ),
                ),
                Text(
                  "YTD 2018",
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            children: <Widget>[
              _buildMonthlyPerformanceBarGraph(
                performancePercentage: _employeePerformance.overallYearlyPerformancePercent,
                label: '',
                timePeriod: DateFormat('MMM yyyy').format(DateTime.now()),
              ),
              SizedBox(height: 12),
              _buildMonthlyPerformanceBarGraph(
                performancePercentage: _employeePerformance.bestPerformancePercent,
                label: 'Best Score',
                timePeriod: '${_employeePerformance.bestPerformanceMonth} ${DateFormat('yyyy').format(DateTime.now())}',
              ),
              SizedBox(height: 16),
              _buildMonthlyPerformanceBarGraph(
                performancePercentage: _employeePerformance.leastPerformancePercent,
                label: 'Least Score',
                timePeriod: '${_employeePerformance.bestPerformanceMonth} ${DateFormat('yyyy').format(DateTime.now())}',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyPerformanceBarGraph({int performancePercentage, String label, String timePeriod}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              '$performancePercentage%',
              textAlign: TextAlign.left,
              style: TextStyle(color: _getColorForPerformance(performancePercentage), fontSize: 16),
            ),
          ),
          LinearPercentIndicator(
            animation: true,
            lineHeight: 4.0,
            animationDuration: 1000,
            percent: performancePercentage / 100,
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: _getColorForPerformance(performancePercentage),
          ),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(label, style: TextStyle(fontSize: 12)),
                Text(
                  timePeriod,
                  style: TextStyle(color: _getColorForPerformance(performancePercentage), fontSize: 12),
                )
              ],
            ),
          ),
        ],
      ),
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
                _getEmployeePerformance();
              },
            ),
          ],
        ),
      ),
    );
  }
}
