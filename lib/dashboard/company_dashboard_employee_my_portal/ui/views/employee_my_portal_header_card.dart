import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/custom_shapes/header_card.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import '../../../../_shared/constants/app_years.dart';
import '../models/graph_value.dart';
import '../presenters/employee_my_portal_dashboard_presenter.dart';

class EmployeeMyPortalHeaderCard extends StatelessWidget {
  final EmployeeMyPortalDashboardPresenter _presenter;

  EmployeeMyPortalHeaderCard(this._presenter);

  @override
  Widget build(BuildContext context) {
    return HeaderCard(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 20),
              Text("My\nPerformance", style: TextStyles.headerCardHeadingTextStyle),
              Expanded(
                child: Text(
                  "YTD   ${AppYears().years().last}",
                  textAlign: TextAlign.end,
                  style: TextStyles.headerCardSubHeadingTextStyle,
                ),
              ),
              SizedBox(width: 20),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 20),
              _ytdPerformanceGraph(),
              SizedBox(width: 12),
              Expanded(
                child: _performanceTile(
                  _presenter.getCurrentMonthPerformance(),
                  "${AppYears().getCurrentMonth()}\nPerformance",
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _performanceTile(
                  _presenter.getCurrentMonthAttendancePerformance(),
                  "${AppYears().getCurrentMonth()}\nAttendance",
                ),
              ),
              SizedBox(width: 20),
            ],
          ),
        ],
      ),
    );
  }

  //MARK: Functions to create ytd performance graph

  Widget _ytdPerformanceGraph() {
    return Container(
      height: 100,
      width: 100,
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Text(
                "${_presenter.getYTDPerformance().value}%",
                style: TextStyles.extraLargeTitleTextStyleBold.copyWith(color: _presenter.getYTDPerformance().color),
              ),
            ),
          ),
          PieChart(
            PieChartData(
              sections: cutoffPerformanceSections(),
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: 41,
              startDegreeOffset: 270.0,
            ),
          ),
          PieChart(
            PieChartData(
              sections: actualPerformanceSections(),
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              startDegreeOffset: 270.0,
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> cutoffPerformanceSections() {
    List<PieChartSectionData> pieChartDataList = [];
    var graphSections = _presenter.getCutoffPerformanceGraphSections();
    for (var graphSection in graphSections) {
      pieChartDataList.add(_generatePieChartData(graphSection, radius: 3));
    }
    return pieChartDataList;
  }

  List<PieChartSectionData> actualPerformanceSections() {
    List<PieChartSectionData> pieChartDataList = [];
    var graphSections = _presenter.getActualPerformanceGraphSections();
    for (var graphSection in graphSections) {
      pieChartDataList.add(_generatePieChartData(graphSection, radius: 6));
    }
    return pieChartDataList;
  }

  PieChartSectionData _generatePieChartData(GraphValue graphSection, {required double radius}) {
    return PieChartSectionData(
      value: graphSection.value.toDouble(),
      color: graphSection.color,
      radius: radius,
      title: '',
    );
  }

  //MARK: Function to create performance tile

  Widget _performanceTile(GraphValue graphValue, String label) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.defaultColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${graphValue.value}%",
            style: TextStyles.largeTitleTextStyleBold.copyWith(color: graphValue.color),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyles.headerCardSubLabelTextStyle.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
