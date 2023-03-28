import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../_shared/constants/app_colors.dart';
import '../../../../common_widgets/restaurant_retail_app_bar.dart';
import '../../presenters/dashboard_presenter.dart';

class RestaurantDashboardAppBar extends StatelessWidget {
  final DashboardPresenter presenter;
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
          SizedBox(height: 6),
          RestaurantRetailAppBar(companyName: presenter.getSelectedCompanyName()),
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
