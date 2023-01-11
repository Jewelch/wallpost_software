import 'package:flutter/material.dart';

import '../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../_shared/constants/app_colors.dart';
import '../../presenters/restaurant_dashboard_presenter.dart';

class SalesBreakDownCard extends StatelessWidget {
  final RestaurantDashboardPresenter _presenter;

  SalesBreakDownCard(this._presenter);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        margin: EdgeInsets.zero,
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
                        _presenter.getBreakdownAtIndex(index).label,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.textColorBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: Row(
                        children: [
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _presenter.getBreakdownAtIndex(index).value,
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.largeTitleTextStyleBold,
                            ),
                          ),
                          SizedBox(width: 6),
                          Column(
                            children: [
                              Text(
                                _presenter.getCompanyCurrency(),
                                style: TextStyle(
                                  color: AppColors.textColorBlueGray,
                                  fontSize: 8, // 11 is not logic
                                  fontWeight: FontWeight.w800,
                                ),
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
              index < _presenter.getNumberOfBreakdowns() - 1 ? Divider(height: 1) : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
