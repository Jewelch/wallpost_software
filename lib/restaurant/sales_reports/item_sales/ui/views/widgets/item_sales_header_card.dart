import 'package:flutter/material.dart';

import '../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../_shared/constants/app_colors.dart';
import '../../../../../restaurant_dashboard/ui/views/widgets/performance_view_holder.dart';
import '../../presenter/item_sales_presenter.dart';

class ItemSalesHeaderCard extends StatelessWidget {
  final ItemSalesPresenter _presenter;
  final double _constraints;

  ItemSalesHeaderCard(this._presenter, this._constraints);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(_constraints > 165 ? 14 : 0),
        topRight: Radius.circular(_constraints > 165 ? 14 : 0),
        bottomLeft: Radius.circular(14),
        bottomRight: Radius.circular(14),
      )),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: _constraints > 165
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SalesElement(
                    backgroundColor: AppColors.lightGreen,
                    label: "Total Revenue(QAR)",
                    value: "1000",
                    // _presenter.getTotalRevenue(),
                    isVertical: true,
                    valueColor: AppColors.green,
                    flex: 2,
                    contraints: _constraints,
                  ),
                  _SalesElement(
                    backgroundColor: AppColors.lightGray,
                    label: "Total Quantity (Items)",
                    value: _presenter.getTotalQuantity(),
                    isVertical: false,
                    valueColor: AppColors.textColorBlack,
                    flex: 1,
                    contraints: _constraints,
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 1,
                    child: _SalesElement(
                      backgroundColor: AppColors.lightGreen,
                      label: "Total Revenue(QAR)",
                      value: "1000",
                      // _presenter.getTotalRevenue(),
                      isVertical: true,
                      valueColor: AppColors.green,
                      flex: 1,
                      contraints: _constraints,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: _SalesElement(
                      backgroundColor: AppColors.lightGray,
                      label: "Total Quantity (Items)",
                      value: _presenter.getTotalQuantity(),
                      isVertical: true,
                      valueColor: AppColors.textColorBlack,
                      flex: 1,
                      contraints: _constraints,
                    ),
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
    required this.isVertical,
    required this.flex,
    required this.contraints,
  });

  final Color backgroundColor;
  final String label;
  final String value;
  final Color valueColor;
  final bool isVertical;
  final int flex;
  final double contraints;

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
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: PerformanceViewHolder(
        radius: defaultRadius,
        backgroundColor: backgroundColor,
        showShadow: false,
        content: isVertical
            ? Column(
                crossAxisAlignment:
                    contraints < 150 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: contraints < 150
                        ? valueStyle2.copyWith(color: valueColor)
                        : valueStyle1.copyWith(color: valueColor),
                  ),
                  SizedBox(height: 2),
                  Text(
                    label,
                    textAlign: TextAlign.start,
                    style: labelStyle,
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: valueStyle2.copyWith(color: valueColor),
                  ),
                  SizedBox(width: 10),
                  Text(
                    label,
                    textAlign: TextAlign.start,
                    style: labelStyle,
                  ),
                ],
              ),
      ),
    );
  }
}
