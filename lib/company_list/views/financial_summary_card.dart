import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/custom_shapes/header_card.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/company_core/entities/financial_summary.dart';

import '../../_shared/constants/app_years.dart';

class FinancialSummaryCard extends StatelessWidget {
  final FinancialSummary _financialSummary;

  FinancialSummaryCard(this._financialSummary);

  @override
  Widget build(BuildContext context) {
    return HeaderCard(
      content: Column(
        children: <Widget>[
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 20),
              Text(
                "Summary",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 30.0,
                ),
              ),
              Expanded(
                child: Text(
                  "YTD ${AppYears.years().first}",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
              SizedBox(width: 20),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 20),
              Text(
                "Profit & Loss",
                style: TextStyles.titleTextStyle.copyWith(color: AppColors.defaultColorDarkContrastColor),
              ),
              Expanded(
                child: Text(_financialSummary.profitLoss.toString(),
                    textAlign: TextAlign.end,
                    style: TextStyles.headerCardLargeTextStyle.copyWith(color: AppColors.headerCardSuccessColor)),
              ),
              SizedBox(width: 20),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              SizedBox(width: 20),
              Expanded(child: Divider(color: AppColors.defaultColorDarkContrastColor)),
              SizedBox(width: 12),
              Expanded(child: Divider(color: AppColors.defaultColorDarkContrastColor)),
              SizedBox(width: 12),
              Expanded(child: Divider(color: AppColors.defaultColorDarkContrastColor)),
              SizedBox(width: 20),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _financialSummaryElement(
                  "Fund Availability",
                  AppColors.headerCardSuccessColor,
                  _financialSummary.cashAvailability.toString(),
                ),
                _financialSummaryElement(
                  "Receivables Overdue",
                  AppColors.headerCardFailureColor,
                  _financialSummary.receivableOverdue.toString(),
                ),
                _financialSummaryElement(
                  "Payables Overdue",
                  AppColors.headerCardFailureColor,
                  _financialSummary.payableOverdue.toString(),
                ),
              ],
            ),
          ),
        ],
      ),
      color: AppColors.defaultColorDark,
    );
  }

  Widget _financialSummaryElement(String label, Color color, String value) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: color,
                fontSize: 20.0,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Color(0xffDFF0F7),
                fontSize: 11.0,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ));
  }
}
