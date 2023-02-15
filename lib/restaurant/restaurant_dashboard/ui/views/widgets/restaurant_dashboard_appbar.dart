import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../_shared/constants/app_colors.dart';
import '../../presenters/restaurant_dashboard_presenter.dart';

class RestaurantDashboardAppBar extends StatelessWidget {
  final RestaurantDashboardPresenter presenter;
  final bool showFilters;

  RestaurantDashboardAppBar(this.presenter, {this.showFilters = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.screenBackgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 6,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 18),
              GestureDetector(
                onTap: Navigator.of(context).pop,
                child: SvgPicture.asset(
                  "assets/icons/arrow_back_icon.svg",
                  color: AppColors.defaultColor,
                  width: 18,
                  height: 18,
                ),
              ),
              SizedBox(width: 18),
              Expanded(
                child: GestureDetector(
                  onTap: Navigator.of(context).pop,
                  child: Container(
                    height: 40,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              child: Text(
                                presenter.getSelectedCompanyName(),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyles.largeTitleTextStyleBold.copyWith(
                                  color: AppColors.defaultColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          SvgPicture.asset(
                            "assets/icons/arrow_down_icon.svg",
                            color: AppColors.defaultColor,
                            width: 16,
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 24),
              SizedBox(width: 12),
            ],
          ),
          if (showFilters)
            Container(
              height: 52,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 18),
                    child: GestureDetector(
                      onTap: () {
                        presenter.onFiltersGotClicked();
                      },
                      child: SvgPicture.asset(
                        "assets/icons/filter_date_icon.svg",
                        width: 18,
                        height: 18,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      presenter.onFiltersGotClicked();
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.lightGray),
                      ),
                      child: Text(
                        presenter.dateFilters.toReadableString(),
                        style: TextStyles.labelTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
