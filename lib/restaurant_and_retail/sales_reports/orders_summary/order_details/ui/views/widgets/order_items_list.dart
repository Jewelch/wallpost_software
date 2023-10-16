import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/orders_summary/order_details/ui/presenter/order_details_presenter.dart';

class OrderItemsList extends StatelessWidget {
  final OrderDetailsPresenter presenter;
  OrderItemsList(this.presenter);

  @override
  Widget build(BuildContext context) {
    final double itemNameWidth = MediaQuery.of(context).size.width * .38;
    const double quantityWidth = 70;
    return presenter.order.orderItems.isEmpty
        ? SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              borderOnForeground: true,
              elevation: 0,
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        SizedBox(
                          width: itemNameWidth,
                          child: Text(
                            "Items",
                            style: TextStyles.labelTextStyle.copyWith(fontWeight: FontWeight.w500),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          width: quantityWidth,
                          child: Text(
                            "Qty.",
                            style: TextStyles.labelTextStyle.copyWith(fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "Revenue",
                          style: TextStyles.labelTextStyle.copyWith(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: presenter.order.orderItems.length,
                    itemBuilder: (context, index) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: itemNameWidth,
                                child: Text(
                                  presenter.order.orderItems[index].name,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: AppColors.textColorBlueGray,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                              SizedBox(
                                width: quantityWidth,
                                child: Text(
                                  presenter.order.orderItems[index].quantity,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: AppColors.textColorBlack,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                              Expanded(
                                  child: Row(
                                children: [
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      presenter.order.orderItems[index].total,
                                      textAlign: TextAlign.right,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyles.largeTitleTextStyleBold,
                                    ),
                                  ),
                                  SizedBox(width: 3),
                                  Column(
                                    children: [
                                      Text(
                                        'QAR',
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
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
