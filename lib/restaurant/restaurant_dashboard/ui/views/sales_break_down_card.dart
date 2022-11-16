import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import '../presenters/restaurant_dashboard_presenter.dart';

class SalesBreakDownCard extends StatelessWidget {
  final RestaurantDashboardPresenter _presenter;

  SalesBreakDownCard(this._presenter);

  @override
  Widget build(BuildContext context) {
    return Padding(
      //fixed
      padding: const EdgeInsets.symmetric(horizontal: 21),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        borderOnForeground: true,
        //fixed
        elevation: 0,
        //fixed
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _presenter.getNumberOfBreakdowns(),
          itemBuilder: (context, index) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                //fixed
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        //Move this to presenter  // Done
                        // _presenter.getSalesBreakdownLabel(index) + ' label label label label',

                        _presenter.getSalesBreakdownLabel(index),
                        //WRONG COLOR & Font
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: AppColors.textColorBlack,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SF-Pro-Display"),
                      ),
                    ),

                    //fixed
                    SizedBox(
                      width: 120,
                      child: Row(
                        children: [
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              //Move this to presenter
                              //  _presenter.getSalesBreakdownValue(index) + ' value value value value',
                              _presenter.getSalesBreakdownValue(index),
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,

                              style: TextStyle(
                                  //WRONG COLOR & Font // Done
                                  color: AppColors.textColorBlack,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: "SF-Pro-Display"),
                            ),
                          ),
                          SizedBox(width: 6),
                          //fixed
                          Column(
                            children: [
                              Text(
                                "QAR",
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
              //fixed
              index < _presenter.getNumberOfBreakdowns() - 1
                  ? //fixed
                  Divider(height: 0)
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
