import 'package:flutter/material.dart';

import '../../../../_common_widgets/graphs/performance_pie_chart.dart';
import '../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../_shared/constants/app_colors.dart';
import '../presenters/manager_my_portal_dashboard_presenter.dart';
import 'performance_view_holder.dart';

class DepartmentPerformanceView extends StatelessWidget {
  final ManagerMyPortalDashboardPresenter _presenter;

  DepartmentPerformanceView(this._presenter);

  @override
  Widget build(BuildContext context) {
    return PerformanceViewHolder(
      showShadow: false,
      backgroundColor: AppColors.lightGray,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          PerformancePieChart(
            size: 50,
            value: _presenter.getDepartmentPerformance().toDouble(),
            valueText: _presenter.getDepartmentPerformanceDisplayValue(),
            valueTextStyle: TextStyles.titleTextStyleBold,
          ),
          SizedBox(width: 24),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _presenter.getDepartmentPerformanceLabel(),
                  style: TextStyles.titleTextStyleBold,
                ),
                Text(
                  "Department Performance",
                  style: TextStyles.smallLabelTextStyle.copyWith(color: AppColors.textColorBlack),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
