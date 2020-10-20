import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/company_management/entities/company_list_item.dart';

class CompanyListCardWithRevenue extends StatelessWidget {
  final CompanyListItem company;
  final VoidCallback onPressed;

  CompanyListCardWithRevenue({this.company, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Card(
          child: Column(
            children: [
              Container(
                child: Text(company.name, style: TextStyle(fontSize: 16)),
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 12, right: 12, top: 12),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text('Approvals'),
                          Spacer(),
                          Text(
                            company.approvalCount.toString(),
                            style: TextStyle(color: AppColors.defaultColor),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 60,
                      color: AppColors.greyColor,
                      margin: EdgeInsets.only(left: 10, right: 10),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                company.actualSalesAmount,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 2, right: 2),
                                child: Text(
                                  company.currencyCode,
                                  style: TextStyle(color: AppColors.labelColor),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Actual',
                            style: TextStyle(color: AppColors.labelColor, fontSize: 9),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          LinearPercentIndicator(
                            percent: getPercentage(),
                            lineHeight: 14,
                            progressColor: getProgressColor(),
                            center: Text(
                              company.achievedSalesPercent.toString() + "%",
                              style: new TextStyle(fontSize: 12.0, color: AppColors.white),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Overall Sales Achievement',
                            style: TextStyle(color: AppColors.labelColor, fontSize: 9),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: onPressed,
    );
  }

  Color getProgressColor() {
    if (company.achievedSalesPercent < 70)
      return Colors.red;
    else if (company.achievedSalesPercent < 80)
      return Colors.orange;
    else
      return Colors.green;
  }

  double getPercentage() {
    if (company.achievedSalesPercent < 1)
      return 0;
    else if (company.achievedSalesPercent > 100)
      return 1;
    else
      return company.achievedSalesPercent / 100;
  }
}
