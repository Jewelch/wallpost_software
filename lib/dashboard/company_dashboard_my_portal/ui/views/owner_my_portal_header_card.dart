import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/custom_shapes/header_card.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import '../../../../../_shared/constants/app_years.dart';
import '../../../../_wp_core/company_management/entities/financial_summary.dart';

class OwnerMyPortalHeaderCard extends StatelessWidget {
  final FinancialSummary _financialSummary;

  OwnerMyPortalHeaderCard(this._financialSummary);

  @override
  Widget build(BuildContext context) {
    return HeaderCard(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 20),
              Text("Financials", style: TextStyles.headerCardHeadingTextStyle),
              Expanded(
                child: Text(
                  "YTD   ${AppYears().years().last}",
                  textAlign: TextAlign.end,
                  style: TextStyles.headerCardSubHeadingTextStyle,
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
                "Profit\nand Loss",
                style: TextStyles.headerCardMainLabelTextStyle,
              ),
              Expanded(
                child: Text(
                  _financialSummary.profitLoss,
                  textAlign: TextAlign.end,
                  style: TextStyles.headerCardMainValueTextStyle.copyWith(
                    color: _financialSummary.isInProfit()
                        ? AppColors.greenOnDarkDefaultColorBg
                        : AppColors.redOnDarkDefaultColorBg,
                  ),
                ),
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
          Row(
            children: [
              SizedBox(width: 20),
              Expanded(
                child: _financialSummaryElement(
                  _financialSummary.availableFunds,
                  "Available\nFunds",
                  _financialSummary.areFundsAvailable()
                      ? AppColors.greenOnDarkDefaultColorBg
                      : AppColors.redOnDarkDefaultColorBg,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _financialSummaryElement(
                  _financialSummary.receivableOverdue,
                  "Receivables\nOverdue",
                  _financialSummary.areReceivablesOverdue()
                      ? AppColors.redOnDarkDefaultColorBg
                      : AppColors.greenOnDarkDefaultColorBg,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _financialSummaryElement(
                  _financialSummary.payableOverdue,
                  "Payables\nOverdue",
                  _financialSummary.arePayablesOverdue()
                      ? AppColors.redOnDarkDefaultColorBg
                      : AppColors.greenOnDarkDefaultColorBg,
                ),
              ),
              SizedBox(width: 20),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _financialSummaryElement(String value, String label, Color textColor) {
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(value,
              style: TextStyles.headerCardSubValueTextStyle.copyWith(
                color: textColor,
              )),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyles.headerCardSubLabelTextStyle,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
