import 'package:flutter/material.dart';

import '../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../_shared/constants/app_colors.dart';
import '../../../../../../crm/common_widgets/performance_view_holder.dart';
import '../../presenters/payables_and_ageing_presenter.dart';

class PayablesHeaderCard extends StatelessWidget {
  final PayablesPresenter _presenter;

  PayablesHeaderCard(this._presenter);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _HeaderElement(
                  backgroundColor: AppColors.lightGray,
                  label: "Overdue",
                  value: _presenter.payablesReport.totalOverDuw,
                  valueColor: _presenter.getOverDueTextColor(_presenter.payablesReport.totalOverDuw),
                ),
                _HeaderElement(
                  backgroundColor: AppColors.lightGray,
                  label: "Due",
                  value: _presenter.payablesReport.totalDue,
                  valueColor: AppColors.textColorBlack,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderElement extends StatelessWidget {
  const _HeaderElement({
    required this.backgroundColor,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final Color backgroundColor;
  final String label;
  final String value;
  final Color valueColor;

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
      child: Container(
        padding: const EdgeInsets.all(4.0),
        child: PerformanceViewHolder(
          radius: defaultRadius,
          backgroundColor: backgroundColor,
          showShadow: false,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: valueStyle.copyWith(color: valueColor),
              ),
              SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.start,
                style: labelStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
