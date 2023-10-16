import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/orders_summary/order_details/ui/presenter/order_details_presenter.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/orders_summary/order_details/ui/view_contracts/order_details_view.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/orders_summary/order_details/ui/views/widgets/order_calculation_widget.dart';

import '../loader/order_detials_loader.dart';
import '../widgets/order_details_error_view.dart';
import '../widgets/order_items_list.dart';

enum _ScreenStates { loading, error, data }

class OrderDetailsPage extends StatefulWidget {
  final int orderId;
  final DateRange dateRange;
  const OrderDetailsPage({super.key, required this.orderId, required this.dateRange});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> implements OrderDetailsView {
  late OrderDetailsPresenter presenter = OrderDetailsPresenter(this, widget.orderId, widget.dateRange);
  final screenStateNotifier = ItemNotifier<_ScreenStates>(defaultValue: _ScreenStates.loading);
  String errorMessage = "";
  @override
  void initState() {
    super.initState();
    presenter.loadOrderDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor2,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "#" + widget.orderId.toString(),
          style: TextStyles.headerCardHeadingTextStyle.copyWith(color: Colors.black, fontWeight: FontWeight.w800),
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: ItemNotifiable<_ScreenStates>(
        notifier: screenStateNotifier,
        builder: (context, currentState) {
          switch (currentState) {
            //$ LOADING STATE
            case _ScreenStates.loading:
              return OrderDetailsLoader();

            //! ERROR STATE
            case _ScreenStates.error:
              return OrderDetailsErrorView(
                errorMessage: errorMessage,
                onRetry: presenter.loadOrderDetails,
              );

            //* DATA STATE
            case _ScreenStates.data:
              return _dataView();
          }
        },
      ),
    );
  }

  Widget _dataView() {
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.screenBackgroundColor,
                AppColors.screenBackgroundColor.withOpacity(.5),
                AppColors.screenBackgroundColor2,
              ],
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    presenter.order.details.date + " " + presenter.order.details.time,
                    style: TextStyles.largeTitleTextStyle.copyWith(color: AppColors.textColorBlueGray),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.textColorBlack,
                    ),
                    child: Text(
                      presenter.order.details.type,
                      style: TextStyles.largeTitleTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total amount paid",
                        style: TextStyles.largeTitleTextStyle.copyWith(
                          color: AppColors.textColorBlueGray,
                          fontSize: 15.0,
                        ),
                      ),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              presenter.order.details.total,
                              style: TextStyles.headerCardSubValueTextStyle.copyWith(
                                color: AppColors.brightGreen,
                                fontSize: 31.0,
                              ),
                            ),
                            Text(
                              presenter.getCompanyCurrency(),
                              style: TextStyles.smallLabelTextStyle.copyWith(
                                color: AppColors.textColorBlueGray,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.textColorBlack),
                    ),
                    child: Text(
                      presenter.order.details.paymentsString,
                      style: TextStyles.largeTitleTextStyle.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        OrderItemsList(presenter),
        SizedBox(height: 24),
        OrderCalculationWidget(presenter),
        SizedBox(height: 40),
      ],
    );
  }

  @override
  void onDidLoadDetails() {
    screenStateNotifier.notify(_ScreenStates.data);
  }

  @override
  void showErrorMessage(String message) {
    screenStateNotifier.notify(_ScreenStates.error);
  }

  @override
  void showLoader() {
    screenStateNotifier.notify(_ScreenStates.loading);
  }
}
