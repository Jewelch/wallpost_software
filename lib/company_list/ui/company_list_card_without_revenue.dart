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
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company.name,
                  style: TextStyles.boldTitleTextStyle,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Approvals', style: TextStyles.subTitleTextStyle),
                    Text(
                      company.approvalCount.toString(),
                      style: TextStyles.subTitleTextStyle
                          .copyWith(color: AppColors.defaultColor),
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
}
