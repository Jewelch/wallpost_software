import 'package:flutter/material.dart';

import '../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../_shared/constants/app_colors.dart';
import '../../../../common_widgets/performance_view_holder.dart';
import '../../presenters/crm_dashboard_presenter.dart';

class CrmDashboardHeaderCard extends StatelessWidget {
  final CrmDashboardPresenter _presenter;

  CrmDashboardHeaderCard(this._presenter);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 185,
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(width: 8),
                    _SalesElement(
                      label: _presenter.getSalesThisYear().label,
                      subLabel: _presenter.getCurrency(),
                      value: _presenter.getSalesThisYear().value,
                      valueColor: _presenter.getSalesThisYear().textColor,
                      backgroundColor: _presenter.getSalesThisYear().backgroundColor,
                    ),
                    SizedBox(width: 2),
                    SizedBox(width: 8),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(width: 8),
                    _SalesElement(
                      label: _presenter.getTargetAchieved().label,
                      value: _presenter.getTargetAchieved().value,
                      valueColor: _presenter.getTargetAchieved().textColor,
                      backgroundColor: _presenter.getTargetAchieved().backgroundColor,
                    ),
                    SizedBox(width: 8),
                    _SalesElement(
                      label: _presenter.getInPipeline().label,
                      value: _presenter.getInPipeline().value,
                      valueColor: _presenter.getInPipeline().textColor,
                      backgroundColor: _presenter.getInPipeline().backgroundColor,
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 24),
        Text(
          "Sales Growth This Year",
          style: TextStyles.headerCardSubValueTextStyle.copyWith(
            color: AppColors.textColorBlack,
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 96,
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(width: 8),
                    _SalesElement(
                      label: _presenter.getLeadConversion().label,
                      value: _presenter.getLeadConversion().value,
                      valueColor: _presenter.getLeadConversion().textColor,
                      backgroundColor: _presenter.getLeadConversion().backgroundColor,
                    ),
                    SizedBox(width: 8),
                    _SalesElement(
                      label: _presenter.getSalesGrowth().label,
                      value: _presenter.getSalesGrowth().value,
                      valueColor: _presenter.getSalesGrowth().textColor,
                      backgroundColor: _presenter.getSalesGrowth().backgroundColor,
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SalesElement extends StatelessWidget {
  final String label;
  final String? subLabel;
  final String value;
  final Color valueColor;
  final Color backgroundColor;

  const _SalesElement({
    required this.label,
    this.subLabel,
    required this.value,
    required this.valueColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    const double defaultRadius = 14;

    final labelStyle = TextStyles.headerCardMainLabelTextStyle.copyWith(
      fontSize: 12.0,
      color: AppColors.textColorBlack,
      fontWeight: FontWeight.w500,
    );

    final valueStyle = TextStyles.headerCardMainValueTextStyle.copyWith(
      fontWeight: FontWeight.w800,
      fontSize: 20.0,
      overflow: TextOverflow.ellipsis,
    );

    return Expanded(
      child: PerformanceViewHolder(
        radius: defaultRadius,
        backgroundColor: backgroundColor,
        showShadow: false,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: valueStyle.copyWith(color: valueColor),
                ),
                if (subLabel != null) SizedBox(width: 4),
                if (subLabel != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(subLabel!, style: TextStyles.labelTextStyle.copyWith(color: valueColor)),
                  ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.start,
              style: labelStyle,
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
