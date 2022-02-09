import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/company_list/entities/company_list_item.dart';

class CompanyListCardWithRevenue extends StatelessWidget {
  final CompanyListItem company;
  final VoidCallback onPressed;

  CompanyListCardWithRevenue({required this.company, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(company.name, style: TextStyles.titleTextStyle.copyWith(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Approval${company.approvalCount == 1 ? '' : 's'}',
                                  style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
                              Text(
                                company.approvalCount.toString(),
                                style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.defaultColor),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Notification  TODO',
                                  style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
                              Text(
                                "TODO",
                                style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.defaultColor),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(height: 80, child: VerticalDivider()),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "company.actualSalesAmount",
                                style: TextStyles.titleTextStyle,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "company.currencyCode",
                                style: TextStyles.labelTextStyle,
                              ),
                            ],
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Actual Sales',
                            style: TextStyles.labelTextStyle,
                          ),
                          SizedBox(height: 16),
                          LinearPercentIndicator(
                            lineHeight: 14,
                            percent: 100,
                            progressColor: _getColorForPerformance(100),
                            center: Text(
                              "100%",
                              style: TextStyles.labelTextStyle.copyWith(color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Overall Sales Achievement',
                            style: TextStyles.labelTextStyle,
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
    );
  }

  Color _getColorForPerformance(int performance) {
    // var performanceLevelCalculator = MyPortalPerformanceLevelCalculator();
    // if (performanceLevelCalculator.isPerformanceGood(performance)) {
    //   return AppColors.goodPerformanceColor;
    // } else if (performanceLevelCalculator.isPerformanceAverage(performance)) {
    //   return AppColors.averagePerformanceColor;
    // } else {
    //   return AppColors.badPerformanceColor;
    // }
    return AppColors.actionButtonColor;
  }
}
