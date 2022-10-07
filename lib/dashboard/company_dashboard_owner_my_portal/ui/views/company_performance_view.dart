import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/views/performance_view_holder.dart';

import '../../../../_common_widgets/text_styles/text_styles.dart';
import '../models/graph_value.dart';
import '../presenters/owner_my_portal_dashboard_presenter.dart';

class CompanyPerformanceView extends StatelessWidget {
  final OwnerMyPortalDashboardPresenter _presenter;

  CompanyPerformanceView(this._presenter);

  @override
  Widget build(BuildContext context) {
    return PerformanceViewHolder(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: 60,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Center(
                    child: Text(
                      "${_presenter.getCompanyPerformance().value}%",
                      style: TextStyles.titleTextStyleBold.copyWith(color: _presenter.getCompanyPerformance().color),
                    ),
                  ),
                ),
                PieChart(
                  PieChartData(
                    sections: cutoffPerformanceSections(),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 25,
                    startDegreeOffset: 270.0,
                  ),
                ),
                PieChart(
                  PieChartData(
                    sections: actualPerformanceSections(),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 25,
                    startDegreeOffset: 270.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "YTD",
                style: TextStyles.labelTextStyleBold,
              ),
              Text(
                "Company\nPerformance",
                style: TextStyles.labelTextStyle.copyWith(color: AppColors.textColorBlack),
              ),
            ],
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
}
