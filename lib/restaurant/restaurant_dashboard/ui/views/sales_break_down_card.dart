import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import '../presenters/restaurant_dashboard_presenter.dart';

class SalesBreakDownCard extends StatelessWidget {
  final RestaurantDashboardPresenter _presenter;

  SalesBreakDownCard(this._presenter);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 7.0,
          mainAxisSpacing: 2.0,
          childAspectRatio: 1.8,
        ),
        itemCount: _presenter.getNumberOfBreakdowns(),
        itemBuilder: (context, index) => Card(
          borderOnForeground: true,
          elevation: 1,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: AppColors.tabDatePickerColor),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Expanded(
                    child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    _presenter.getBreakdownAtIndex(index).value,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: _presenter.getBreakdownAtIndex(index).textColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w600),
                  ),
                )),
                SizedBox(height: 4),
                Expanded(
                  child: Text(
                    _presenter.getBreakdownAtIndex(index).label,
                    style: TextStyle(
                      color: AppColors.textColorDarkGray,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
