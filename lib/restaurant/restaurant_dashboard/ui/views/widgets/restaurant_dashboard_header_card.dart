import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/views/performance_view_holder.dart';

import '../../presenters/restaurant_dashboard_presenter.dart';

class RestaurantDashboardHeaderCard extends StatelessWidget {
  final RestaurantDashboardPresenter _presenter;

  RestaurantDashboardHeaderCard(this._presenter);

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
                _SalesElement(
                  backgroundColor: AppColors.lightGreen,
                  label: "Total Sales",
                  value: _presenter.getTotalSales(),
                  valueColor: AppColors.green,
                ),
                _SalesElement(
                  backgroundColor: AppColors.lightGreen,
                  label: "Net Sales",
                  value: _presenter.getNetSale(),
                  valueColor: AppColors.green,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SalesElement(
                  backgroundColor: AppColors.lightYellow,
                  label: "Cost of Sales",
                  value: _presenter.getCostOfSales(),
                  valueColor: AppColors.textColorBlack,
                ),
                _SalesElement(
                  backgroundColor: AppColors.lightGray,
                  label: "Gross Profit",
                  value: _presenter.getGrossProfit(),
                  valueColor: AppColors.yellow,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SalesElement extends StatelessWidget {
  const _SalesElement({
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
      fontFamily: "SF-Pro-Display",
    );

    final valueStyle = TextStyles.headerCardMainValueTextStyle.copyWith(
      fontWeight: FontWeight.w800,
      fontSize: 17.0,
      fontFamily: "SF-Pro-Display",
      overflow: TextOverflow.ellipsis,
    );

    return Expanded(
      child: Padding(
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
