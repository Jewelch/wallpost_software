import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_wp_core/company_management/entities/company_list_item.dart';
import 'package:wallpost/my_portal/services/my_portal_performance_level_calculator.dart';

class CompanyListCardWithRevenue extends StatelessWidget {
  final CompanyListItem company;
  final VoidCallback onPressed;

  CompanyListCardWithRevenue({this.company, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(company.name, style: TextStyles.boldTitleTextStyle),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Approvals',
                              style: TextStyles.subTitleTextStyle),
                          Text(
                            company.approvalCount.toString(),
                            style: TextStyles.subTitleTextStyle
                                .copyWith(color: AppColors.defaultColor),
                          ),
                        ],
                      ),
                    ),
                    Container(height: 60, child: VerticalDivider()),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                company.actualSalesAmount,
                                style: TextStyles.titleTextStyle,
                              ),
                              SizedBox(width: 4),
                              Text(
                                company.currencyCode,
                                style: TextStyles.currencyTextStyle,
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Actual Revenue',
                            style: TextStyles.smallSubTitleTextStyle,
                          ),
                          SizedBox(height: 4),
                          LinearPercentIndicator(
                            lineHeight: 14,
                            percent: company.achievedSalesPercent / 100,
                            progressColor: _getColorForPerformance(
                                company.achievedSalesPercent.toInt()),
                            center: Text(
                              company.achievedSalesPercent.toString() + "%",
                              style: TextStyles.progressBarTextStyle,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Overall Sales Achievement',
                            style: TextStyles.smallSubTitleTextStyle,
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      onTap: onPressed,
    );
  }

  Color _getColorForPerformance(int performance) {
    var performanceLevelCalculator = MyPortalPerformanceLevelCalculator();
    if (performanceLevelCalculator.isPerformanceGood(performance)) {
      return AppColors.goodPerformanceColor;
    } else if (performanceLevelCalculator.isPerformanceAverage(performance)) {
      return AppColors.averagePerformanceColor;
    } else {
      return AppColors.badPerformanceColor;
    }
  }
}
//TODO: Review performance classes
