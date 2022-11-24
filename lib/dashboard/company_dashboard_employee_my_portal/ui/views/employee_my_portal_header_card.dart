import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/custom_shapes/header_card.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import '../../../../_common_widgets/graphs/performance_pie_chart.dart';
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
              PerformancePieChart(
                  size: 100,
                  value: _presenter.getYTDPerformance().value.toDouble(),
                  valueText: "${_presenter.getYTDPerformance().value}%",
                  valueTextStyle: TextStyles.extraLargeTitleTextStyleBold),
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
