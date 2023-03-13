import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/crm/dashboard/ui/presenters/crm_dashboard_presenter.dart';

import '../../../entities/staff_performance.dart';

class CrmDashboardStaffPerformanceTile extends StatelessWidget {
  final CrmDashboardPresenter _presenter;
  final StaffPerformance _staffPerformance;

  CrmDashboardStaffPerformanceTile(this._presenter, this._staffPerformance);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14.0),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Image.network(
                _presenter.getStaffProfileImageUrl(_staffPerformance),
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(color: AppColors.lightGreen);
                },
                errorBuilder: (context, error, stack) {
                  return Container(color: AppColors.lightGreen);
                },
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _presenter.getStaffName(_staffPerformance),
                  style: TextStyles.largeTitleTextStyle,
                ),
                SizedBox(height: 4),
                Wrap(
                  children: [
                    Text("Target: ", style: TextStyles.subTitleTextStyle),
                    Text(_presenter.getStaffTargetAmount(_staffPerformance), style: TextStyles.subTitleTextStyle),
                    SizedBox(width: 2),
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Text(_presenter.getCurrency(),
                          style: TextStyles.smallLabelTextStyle.copyWith(color: AppColors.textColorBlueGray)),
                    ),
                    SizedBox(width: 16),
                    Text("Actual: ", style: TextStyles.subTitleTextStyle),
                    Text(_presenter.getStaffActualAmount(_staffPerformance), style: TextStyles.subTitleTextStyle),
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
            _presenter.getStaffPerformancePercentage(_staffPerformance).value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.largeTitleTextStyleBold.copyWith(
              color: _presenter.getStaffPerformancePercentage(_staffPerformance).textColor,
            ),
          ),
        ],
      ),
    );
  }
}
