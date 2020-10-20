import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/company_management/entities/company_list_item.dart';

class CompanyListCardWithOutRevenue extends StatelessWidget {
  final CompanyListItem company;
  final VoidCallback onPressed;

  CompanyListCardWithOutRevenue({this.company, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Card(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Text(
                  company.name,
                  style: TextStyle(fontSize: 16),
                ),
                alignment: Alignment.topLeft,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                child: Row(
                  children: [
                    Text('Approvals'),
                    Spacer(),
                    Text(
                      company.approvalCount.toString(),
                      style: TextStyle(color: AppColors.defaultColor),
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
}
