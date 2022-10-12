import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/custom_shapes/header_card.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/aggregated_sales_data.dart';

class RestaurantDashboardHeaderCard extends StatelessWidget {
  final AggregatedSalesData _salesData;

  RestaurantDashboardHeaderCard(this._salesData);

  @override
  Widget build(BuildContext context) {
    return HeaderCard(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: Text(_salesData.totalSales, style: TextStyles.headerCardHeadingTextStyle),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .2,
              ),
              Expanded(
                flex: 1,
                child: Text(
                  _salesData.netSales,
                  textAlign: TextAlign.start,
                  style: TextStyles.headerCardHeadingTextStyle,
                ),
              ),
              SizedBox(width: 40),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: Text("Total Sale", style: TextStyles.headerCardMoneyLabelTextStyle),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .2,
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "Net Sale",
                  textAlign: TextAlign.start,
                  style: TextStyles.headerCardMoneyLabelTextStyle,
                ),
              ),
              SizedBox(width: 40),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 10),
              Expanded(
                  child: Divider(
                color: AppColors.bannerBackgroundColor,
              )),
              SizedBox(width: 20),
              Expanded(child: Divider(color: AppColors.bannerBackgroundColor)),
              SizedBox(width: 10),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: Text(_salesData.costOfSales, style: TextStyles.headerCardHeadingTextStyle),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .2,
              ),
              Expanded(
                flex: 1,
                child: Text(
                  _salesData.grossOfProfit,
                  textAlign: TextAlign.start,
                  style: TextStyles.headerCardHeadingTextStyleWithGreenColor,
                ),
              ),
              SizedBox(width: 40),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: Text("Cost of Sales", style: TextStyles.headerCardMoneyLabelTextStyle),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .2,
              ), //
              Expanded(
                flex: 1,
                child: Text(
                  "Gross Profit",
                  textAlign: TextAlign.start,
                  style: TextStyles.headerCardMoneyLabelTextStyle,
                ),
              ),
              SizedBox(width: 40),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
