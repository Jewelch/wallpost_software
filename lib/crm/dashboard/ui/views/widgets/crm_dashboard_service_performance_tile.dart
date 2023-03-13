import 'package:flutter/material.dart';
import 'package:wallpost/crm/dashboard/ui/presenters/crm_dashboard_presenter.dart';

import '../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../_shared/constants/app_colors.dart';
import '../../../entities/service_performance.dart';

class CrmDashboardServicePerformanceTile extends StatelessWidget {
  final CrmDashboardPresenter _presenter;
  final ServicePerformance _servicePerformance;

  CrmDashboardServicePerformanceTile(this._presenter, this._servicePerformance);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _presenter.getServiceName(_servicePerformance),
                  style: TextStyles.largeTitleTextStyle,
                ),
                SizedBox(height: 4),
                Wrap(
                  children: [
                    Text("Target: ", style: TextStyles.subTitleTextStyle),
                    Text(_presenter.getServiceTargetAmount(_servicePerformance), style: TextStyles.subTitleTextStyle),
                    SizedBox(width: 2),
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Text(_presenter.getCurrency(),
                          style: TextStyles.smallLabelTextStyle.copyWith(color: AppColors.textColorBlueGray)),
                    ),
                    SizedBox(width: 16),
                    Text("Actual: ", style: TextStyles.subTitleTextStyle),
                    Text(_presenter.getServiceActualAmount(_servicePerformance), style: TextStyles.subTitleTextStyle),
                    SizedBox(width: 2),
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Text(_presenter.getCurrency(),
                          style: TextStyles.smallLabelTextStyle.copyWith(color: AppColors.textColorBlueGray)),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(width: 8),
          Text(
            _presenter.getServicePerformancePercentage(_servicePerformance).value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.largeTitleTextStyleBold.copyWith(
              color: _presenter.getServicePerformancePercentage(_servicePerformance).textColor,
            ),
          ),
        ],
      ),
    );
  }
}
