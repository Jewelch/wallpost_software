import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/finance/dashboard/ui/presenters/finance_dashboard_presenter.dart';

import '../../../../_shared/constants/app_years.dart';

class FinanceDashboardAppBar extends StatelessWidget {
  final FinanceDashboardPresenter presenter;

  FinanceDashboardAppBar(this.presenter);

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
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 12),
              GestureDetector(
                onTap: Navigator.of(context).pop,
                child: Container(
                  color: Colors.white,
                  width: 40,
                  height: 40,
                  child: Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: SvgPicture.asset(
                        "assets/icons/arrow_back_icon.svg",
                        colorFilter: ColorFilter.mode(AppColors.defaultColor, BlendMode.srcIn),
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
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
                              presenter.getSelectedCompany().name,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyles.largeTitleTextStyleBold
                                  .copyWith(color: AppColors.defaultColor, fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(width: 8),
                          SvgPicture.asset(
                            "assets/icons/arrow_down_icon.svg",
                            colorFilter: ColorFilter.mode(AppColors.defaultColor, BlendMode.srcIn),
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
                    onTap: () => presenter.initiateFilterSelection(),
                    child: SvgPicture.asset(
                      "assets/icons/filter_icon.svg",
                      width: 18,
                      height: 18,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                GestureDetector(
                  onTap: () => presenter.initiateFilterSelection(),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.lightGray),
                    ),
                    child: Text(
                      _getMonthNamesForSelectedYear()[presenter.selectedMonth],
                      style: TextStyles.labelTextStyle.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                GestureDetector(
                  onTap: () => presenter.initiateFilterSelection(),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.lightGray),
                    ),
                    child: Text(
                      presenter.selectedYear.toString(),
                      style: TextStyles.labelTextStyle.copyWith(fontWeight: FontWeight.w500),
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

  //MARK: Functions to get months

  List<String> _getMonthNamesForSelectedYear() {
    var years = AppYears().currentAndPastShortenedMonthsOfYear(presenter.selectedYear);
    years.insert(0, "YTD");
    return years;
  }
}
