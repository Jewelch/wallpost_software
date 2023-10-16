import 'package:flutter/widgets.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/orders_summary/order_details/ui/presenter/order_details_presenter.dart';

class OrderCalculationWidget extends StatelessWidget {
  final OrderDetailsPresenter presenter;
  const OrderCalculationWidget(this.presenter, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16 + 24),
      child: Column(
        children: [
          SizedBox(height: 10),
          _Item(
            title: "Sub total",
            value: presenter.order.summary.subTotal,
            color: null,
            currency: presenter.getCompanyCurrency(),
          ),
          SizedBox(height: 20),
          _Item(
            title: "Discount",
            value: (presenter.order.summary.discountPrice > 0 ? "-" : "") + presenter.order.summary.discount,
            color: (presenter.order.summary.discountPrice <= 0 ? null : AppColors.red),
            currency: presenter.getCompanyCurrency(),
          ),
          SizedBox(height: 20),
          _Item(
            title: "Tax",
            value:(presenter.order.summary.taxPrice > 0 ? "-" : "") + presenter.order.summary.tax,
             color: (presenter.order.summary.taxPrice <= 0 ? null : AppColors.red),
            currency: presenter.getCompanyCurrency(),
          ),
          SizedBox(height: 20),
          _Item(
            title: "Total",
            value: presenter.order.summary.total,
            color: AppColors.brightGreen,
            currency: presenter.getCompanyCurrency(),
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String title;
  final String value;
  final String currency;
  final Color? color;
  const _Item({
    required this.title,
    required this.value,
    required this.currency,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            color: AppColors.textColorBlueGray,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
        Row(
          children: [
            SizedBox(width: 8),
            Text(value,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.largeTitleTextStyleBold.copyWith(
                  color: color,
                )),
            SizedBox(width: 3),
            Column(
              children: [
                Text(
                  currency,
                  style: TextStyle(
                    color: AppColors.textColorBlueGray,
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 3),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
