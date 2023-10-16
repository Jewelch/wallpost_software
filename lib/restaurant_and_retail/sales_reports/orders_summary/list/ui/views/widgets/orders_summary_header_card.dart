import 'package:flutter/material.dart';

import '../../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../../_shared/constants/app_colors.dart';
import '../../../../../../common_widgets/performance_view_holder.dart';
import '../../presenter/orders_summary_presenter.dart';

class OrdersSummaryHeaderCard extends StatelessWidget {
  final OrdersSummaryPresenter presenter;
  final double constraints;

  const OrdersSummaryHeaderCard(
    this.presenter,
    this.constraints, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shadowColor: AppColors.shimmerColor,
      elevation: constraints < 75 ? 10 : 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(constraints > 95 ? 14 : 0),
        topRight: Radius.circular(constraints > 95 ? 14 : 0),
        bottomLeft: Radius.circular(constraints > 90 ? 14 : 0),
        bottomRight: Radius.circular(constraints > 90 ? 14 : 0),
      )),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child:  constraints > 80 || false
            ? _SalesElement(
                backgroundColor: AppColors.lightGreen,
                label: "Total Sales(${presenter.getCompanyCurrency()})",
                value: presenter.ordersSummary?.total ?? "",
                isVertical: true,
                valueColor: AppColors.green,
                flex: 1,
                constraints: constraints,
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _SalesElement(
                  backgroundColor: AppColors.lightGreen,
                  label: "Total Sales(${presenter.getCompanyCurrency()})",
                  value: presenter.ordersSummary?.total ?? "",
                  isVertical: true,
                  valueColor: AppColors.green,
                  flex: 1,
                  constraints: constraints,
                ),
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
    required this.isVertical,
    required this.flex,
    required this.constraints,
  });

  final Color backgroundColor;
  final String label;
  final String value;
  final Color valueColor;
  final bool isVertical;
  final int flex;
  final double constraints;

  @override
  Widget build(BuildContext context) {
    const double defaultRadius = 14;

    final labelStyle = TextStyles.headerCardMainLabelTextStyle.copyWith(
      fontSize: 12.0,
      color: AppColors.textColorBlack,
      fontWeight: FontWeight.w500,
    );

    final valueStyle1 = TextStyles.headerCardMainValueTextStyle.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 34.0,
      overflow: TextOverflow.ellipsis,
    );
    final valueStyle2 = TextStyles.headerCardMainValueTextStyle.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 17.0,
      overflow: TextOverflow.ellipsis,
    );
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: constraints < 165 ? 0 : 4),
      child: PerformanceViewHolder(
          radius: defaultRadius,
          backgroundColor: backgroundColor,
          showShadow: false,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          content: Column(
            crossAxisAlignment:  CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: constraints < 100
                    ? valueStyle2.copyWith(color: valueColor)
                    : valueStyle1.copyWith(color: valueColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2),
              Text(
                label,
                textAlign: TextAlign.center,
                style: labelStyle,
              ),
            ],
          )),
    );
  }
}
