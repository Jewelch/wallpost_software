import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/custom_shapes/header_card.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import '../../../../../../_shared/constants/app_years.dart';
import '../../../../../_wp_core/company_management/entities/financial_summary.dart';
import '../models/finance_detail.dart';
import '../presenters/finance_detail_card_presenter.dart';

class FinanceDetailCard extends StatelessWidget {
  final FinanceDetailCardPresenter _presenter;

  FinanceDetailCard(FinancialSummary financialSummary) : _presenter = FinanceDetailCardPresenter(financialSummary);

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
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Financials ", style: TextStyles.headerCardHeadingTextStyle),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(_presenter.getCurrency(), style: TextStyles.headerCardSubLabelTextStyle),
                  ),
                ],
              ),
              Expanded(
                child: Text(
                  "YTD  ${AppYears().years().last}",
                  textAlign: TextAlign.end,
                  style: TextStyles.headerCardSubHeadingTextStyle,
                ),
              ),
              SizedBox(width: 20),
            ],
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _presenter.getProfitLossDetails().value,
                style: TextStyles.headerCardMainValueTextStyle.copyWith(
                  color: _presenter.getProfitLossDetails().valueColor,
                ),
              ),
              Text(
                _presenter.getProfitLossDetails().label,
                textAlign: TextAlign.center,
                style: TextStyles.headerCardSubLabelTextStyle,
              ),
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
              Expanded(child: _financialSummaryElement(_presenter.getAvailableFundsDetails())),
              SizedBox(width: 12),
              Expanded(child: _financialSummaryElement(_presenter.getOverdueReceivablesDetails())),
              SizedBox(width: 12),
              Expanded(child: _financialSummaryElement(_presenter.getOverduePayablesDetails())),
              SizedBox(width: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _financialSummaryElement(FinanceDetail financeDetail) {
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(financeDetail.value,
              style: TextStyles.headerCardSubValueTextStyle.copyWith(color: financeDetail.valueColor)),
        ),
        SizedBox(height: 2),
        Text(
          financeDetail.label,
          style: TextStyles.headerCardSubLabelTextStyle,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
