import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/custom_shapes/header_card.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/sales_data/entities/sales_data.dart';

class SalesDataHeaderCard extends StatelessWidget {
  final SalesData _salesData;

  SalesDataHeaderCard(this._salesData);

  @override
  Widget build(BuildContext context) {
    return HeaderCard(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 20),
              Text(_salesData.totalSales, style: TextStyles.headerCardHeadingTextStyle),
              Expanded(
                child: Text(
                  _salesData.netSales,
                  textAlign: TextAlign.end,
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
              Text("Total Sale", style: TextStyles.headerCardMoneyLabelTextStyle),
              Expanded(
                child: Text(
                  "Net Sale",
                  textAlign: TextAlign.end,
                  style: TextStyles.headerCardMoneyLabelTextStyle,
                ),
              ),
              SizedBox(width: 40),
            ],
          ),
          SizedBox(
            height: 20,
          ),
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
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 20),
              Text(_salesData.costOfSales, style: TextStyles.headerCardHeadingTextStyle),
              Expanded(
                child: Text(
                  _salesData.grossOfProfit,
                  textAlign: TextAlign.end,
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
              Text("Cost of Sales", style: TextStyles.headerCardMoneyLabelTextStyle),
              Expanded(
                child: Text(
                  "Gross Profit",
                  textAlign: TextAlign.end,
                  style: TextStyles.headerCardMoneyLabelTextStyle,
                ),
              ),
              SizedBox(width: 40),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
