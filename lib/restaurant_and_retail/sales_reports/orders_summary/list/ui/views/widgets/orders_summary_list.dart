import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/orders_summary/list/ui/presenter/orders_summary_presenter.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/orders_summary/order_details/ui/views/pages/order_details_page.dart';

import '../../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../../_shared/constants/app_colors.dart';

class OrdersSummaryList extends StatelessWidget {
  final OrdersSummaryPresenter presenter;
  const OrdersSummaryList(this.presenter, {super.key});

  @override
  Widget build(BuildContext context) {
    var orders = presenter.ordersSummary?.orders ?? [];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: orders.length,
          itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: InkWell(
                  onTap: () {
                    ScreenPresenter.present(
                      OrderDetailsPage(
                        orderId: orders[index].id,
                        dateRange: presenter.filters,
                      ),
                      context,
                    );
                  },
                  child: Card(
                    shadowColor: Colors.black,
                    color: Colors.white,
                    elevation: 3,
                    shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(32)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 27, bottom: 24, left: 16, right: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  orders[index].date + " " + orders[index].time,
                                  style: TextStyles.titleTextStyle.copyWith(color: AppColors.textColorBlueGray),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Order# " + orders[index].num.toString(),
                                  style: TextStyles.headerCardSubValueTextStyle.copyWith(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4), color: Color.fromRGBO(240, 245, 250, 1)),
                                child: Text(
                                  orders[index].paymentsString,
                                  style: TextStyles.labelTextStyle
                                      .copyWith(color: AppColors.textColorBlueGray, fontSize: 13.0),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      orders[index].total,
                                      style: TextStyles.headerCardSubValueTextStyle.copyWith(
                                        color: AppColors.brightGreen,
                                      ),
                                    ),
                                    Text(
                                      presenter.getCompanyCurrency(),
                                      style: TextStyles.smallLabelTextStyle.copyWith(
                                        color: AppColors.textColorBlueGray,
                                        fontSize: 8.0,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
    );
  }
}
