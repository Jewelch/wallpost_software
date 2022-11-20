import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/presenters/restaurant_dashboard_presenter.dart';

class RestaurantDashboardAppBar extends StatelessWidget {
  final RestaurantDashboardPresenter presenter;

  RestaurantDashboardAppBar(this.presenter);

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
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 12),
              GestureDetector(
                onTap: Navigator.of(context).pop,
                child: SvgPicture.asset(
                  "assets/icons/arrow_back_icon.svg",
                  color: AppColors.defaultColor,
                  width: 16,
                  height: 16,
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: GestureDetector(
                  onTap: Navigator.of(context).pop,
                  child: Container(
                    height: 40,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              presenter.getSelectedCompanyName(),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyles.largeTitleTextStyleBold.copyWith(
                                color: AppColors.defaultColor,
                                fontFamily: "SF-Pro-Display",
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
                SizedBox(
                  width: 16,
                ),
                GestureDetector(
                  onTap: () {
                    presenter.onFiltersGotClicked();
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.lightGray),
                    ),
                    child: Text(
                      presenter.dateFilters.selectedRangeOption.toReadableString(),
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
