import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import '../../presenters/restaurant_dashboard_presenter.dart';

class SalesBreakDownCard extends StatelessWidget {
  final RestaurantDashboardPresenter _presenter;

  SalesBreakDownCard(this._presenter);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        borderOnForeground: true,
        elevation: 0,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _presenter.getNumberOfBreakdowns(),
          itemBuilder: (context, index) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        // _presenter.getSalesBreakdownLabel(index) + ' label label label label',

                        _presenter.getSalesBreakdownLabel(index),
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: AppColors.textColorBlack,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SF-Pro-Display"),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: Row(
                        children: [
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              //  _presenter.getSalesBreakdownValue(index) + ' value value value value',
                              _presenter.getSalesBreakdownValue(index),
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,

                              style: TextStyle(
                                  color: AppColors.textColorBlack,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: "SF-Pro-Display"),
                            ),
                          ),
                          SizedBox(width: 6),
                          Column(
                            children: [
                              Text(
                                _presenter.getCompanyCurrency(),
                                style: TextStyle(
                                    color: AppColors.moneySuffixColor,
                                    fontSize: 8, // 11 is not logic
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "SF-Pro-Display"),
                              ),
                              SizedBox(height: 3),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              index < _presenter.getNumberOfBreakdowns() - 1 ? Divider(height: 0) : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
