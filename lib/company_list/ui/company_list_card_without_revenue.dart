import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_wp_core/company_management/entities/company_list_item.dart';

class CompanyListCardWithOutRevenue extends StatelessWidget {
  final CompanyListItem company;
  final VoidCallback onPressed;

  CompanyListCardWithOutRevenue({this.company, this.onPressed});

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
                Text(
                  company.name,
                  style: TextStyles.titleTextStyle.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            company.approvalCount.toString(),
                            style: TextStyles.titleTextStyle.copyWith(color: AppColors.defaultColor),
                          ),
                          SizedBox(height: 6),
                          Text('Approval${company.approvalCount == 1 ? '' : 's'}',
                              style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            company.notificationCount.toString(),
                            style: TextStyles.titleTextStyle.copyWith(color: AppColors.defaultColor),
                          ),
                          SizedBox(height: 6),
                          Text('Notification${company.notificationCount == 1 ? '' : 's'}',
                              style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
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
}
