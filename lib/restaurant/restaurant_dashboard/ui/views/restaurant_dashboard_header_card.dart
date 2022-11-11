import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/custom_shapes/header_card.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import '../presenters/restaurant_dashboard_presenter.dart';

class RestaurantDashboardHeaderCard extends StatelessWidget {
  final RestaurantDashboardPresenter _presenter;

  RestaurantDashboardHeaderCard(this._presenter);

  @override
  Widget build(BuildContext context) {
    return HeaderCard(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Text(
                  _presenter.getTotalSales(),
                  style: TextStyles.headerCardMainValueTextStyle.copyWith(color: Colors.white),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * .2),
              Expanded(
                flex: 1,
                child: Text(
                  _presenter.getNetSale(),
                  textAlign: TextAlign.start,
                  style: TextStyles.headerCardMainValueTextStyle.copyWith(color: Colors.white),
                ),
              ),
              SizedBox(width: 40),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Text("Total Sale", style: TextStyles.headerCardMainLabelTextStyle),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * .2),
              Expanded(
                flex: 1,
                child: Text(
                  "Net Sale",
                  textAlign: TextAlign.start,
                  style: TextStyles.headerCardMainLabelTextStyle,
                ),
              ),
              SizedBox(width: 40),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 18),
              Expanded(child: Divider(color: AppColors.bannerBackgroundColor)),
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
              SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Text(
                  _presenter.getCostOfSales(),
                  style: TextStyles.headerCardMainValueTextStyle.copyWith(color: Colors.white),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * .2),
              Expanded(
                flex: 1,
                child: Text(
                  _presenter.getGrossProfit(),
                  textAlign: TextAlign.start,
                  style: TextStyles.headerCardMainValueTextStyle.copyWith(
                    color: _presenter.getGrossProfitTextColor(),
                  ),
                ),
              ),
              SizedBox(width: 40),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Text("Cost of Sales", style: TextStyles.headerCardMainLabelTextStyle),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * .2),
              Expanded(
                flex: 1,
                child: Text(
                  "Gross Profit",
                  textAlign: TextAlign.start,
                  style: TextStyles.headerCardMainLabelTextStyle,
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
