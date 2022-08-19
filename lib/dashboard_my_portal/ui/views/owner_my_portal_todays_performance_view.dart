import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wallpost/dashboard_my_portal/ui/presenters/owner_my_portal_dashboard_presenter.dart';

import '../../../_common_widgets/text_styles/text_styles.dart';
import '../../../_shared/constants/app_colors.dart';
import '../models/graph_section.dart';

class OwnerMyPerformanceTodaysPerformanceView extends StatelessWidget {
  final OwnerMyPortalDashboardPresenter _presenter;

  OwnerMyPerformanceTodaysPerformanceView(this._presenter);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text("Today", style: TextStyles.titleTextStyleBold),
        ),
        SizedBox(height: 12),
        _ytdPerformanceTile(),
        SizedBox(height: 12),
        _staffAbsencesTile(),
      ],
    );
  }

  //MARK: Functions to create ytd performance tile

  Widget _ytdPerformanceTile() {
    return _performanceTile(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 120,
            width: 120,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Center(
                    child: Text(
                      "${_presenter.getCompanyPerformance().value}%",
                      style: TextStyles.extraLargeTitleTextStyleBold
                          .copyWith(color: _presenter.getCompanyPerformance().color),
                    ),
                  ),
                ),
                PieChart(
                  PieChartData(
                    sections: cutoffPerformanceSections(),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 51,
                    startDegreeOffset: 270.0,
                  ),
                ),
                PieChart(
                  PieChartData(
                    sections: actualPerformanceSections(),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 50,
                    startDegreeOffset: 270.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Text(
            "YTD\nCompany performance",
            style: TextStyles.titleTextStyleBold,
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

  //MARK: Functions to create staff absences tile

  Widget _staffAbsencesTile() {
    if (_presenter.getAbsenteesData().numberOfAbsentees == 0) return Container();

    return _performanceTile(
      content: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${_presenter.getAbsenteesData().numberOfAbsentees}",
              style: TextStyles.extraLargeTitleTextStyleBold.copyWith(
                color: _presenter.getAbsenteesData().countTextColor,
              ),
            ),
            SizedBox(width: 10),
            Text(
              "Staff Absences",
              style: TextStyles.titleTextStyleBold,
            ),
          ],
        ),
      ),
    );
  }

  //MARK: Function to create a tile

  Widget _performanceTile({required Widget content}) {
    return Container(
      margin: EdgeInsets.only(left: 12, right: 12),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.screenBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.defaultColorDarkContrastColor.withOpacity(0.3),
            offset: Offset(0, 0),
            blurRadius: 40,
            spreadRadius: 0,
          ),
        ],
      ),
      child: content,
    );
  }


}
