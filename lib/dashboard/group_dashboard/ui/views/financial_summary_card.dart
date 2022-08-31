import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/custom_shapes/header_card.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/dashboard/group_dashboard/ui/presenters/group_dashboard_presenter.dart';

import '../../../../../_shared/constants/app_years.dart';
import '../../../../_wp_core/company_management/entities/financial_summary.dart';
import '../models/financial_details.dart';

class FinancialSummaryCard extends StatelessWidget {
  final GroupDashboardPresenter _presenter;
  final FinancialSummary _financialSummary;

  FinancialSummaryCard(this._presenter, this._financialSummary);

  @override
  Widget build(BuildContext context) {
    return HeaderCard(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                _presenter.getProfitLossDetails(_financialSummary, isForHeaderCard: true).label,
                style: TextStyles.headerCardMainLabelTextStyle,
              ),
              Expanded(
                child: Text(
                  _presenter.getProfitLossDetails(_financialSummary, isForHeaderCard: true).value,
                  textAlign: TextAlign.end,
                  style: TextStyles.headerCardMainValueTextStyle.copyWith(
                    color: _presenter.getProfitLossDetails(_financialSummary, isForHeaderCard: true).textColor,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: _financialSummaryElement(_presenter.getAvailableFundsDetails(
                    _financialSummary,
                    isForHeaderCard: true,
                  )),
                ),
                Flexible(
                  child: _financialSummaryElement(_presenter.getOverdueReceivablesDetails(
                    _financialSummary,
                    isForHeaderCard: true,
                  )),
                ),
                Flexible(
                  child: _financialSummaryElement(_presenter.getOverduePayablesDetails(
                    _financialSummary,
                    isForHeaderCard: true,
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _financialSummaryElement(FinancialDetails financialDetails) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(financialDetails.value,
                  style: TextStyles.headerCardSubValueTextStyle.copyWith(
                    color: financialDetails.textColor,
                  )),
            ),
            Text(financialDetails.label, style: TextStyles.headerCardSubLabelTextStyle)
          ],
        ));
  }
}
