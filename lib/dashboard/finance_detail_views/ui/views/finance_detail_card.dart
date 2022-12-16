import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/custom_shapes/header_card.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import '../../../../../_wp_core/company_management/entities/financial_summary.dart';
import '../models/finance_detail.dart';
import '../presenters/finance_detail_card_presenter.dart';

class FinanceDetailCard extends StatelessWidget {
  final FinanceDetailCardPresenter _presenter;

  FinanceDetailCard(FinancialSummary financialSummary) : _presenter = FinanceDetailCardPresenter(financialSummary);

  @override
  Widget build(BuildContext context) {
    return HeaderCard(
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Financials ", style: TextStyles.headerCardHeadingTextStyle),
                _presenter.shouldShowDetailDisclosureIndicator()
                    ? Container(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        height: 12,
                        width: 12,
                        child: SvgPicture.asset(
                          'assets/icons/arrow_forward.svg',
                          width: 12,
                          height: 12,
                          color: AppColors.defaultColor,
                        ),
                      )
                    : Container(),
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
                Expanded(child: Divider(color: AppColors.defaultColorDarkContrastColor)),
                SizedBox(width: 12),
                Expanded(child: Divider(color: AppColors.defaultColorDarkContrastColor)),
                SizedBox(width: 12),
                Expanded(child: Divider(color: AppColors.defaultColorDarkContrastColor)),
              ],
            ),
            Row(
              children: [
                Expanded(child: _financialSummaryElement(_presenter.getAvailableFundsDetails())),
                SizedBox(width: 12),
                Expanded(child: _financialSummaryElement(_presenter.getOverdueReceivablesDetails())),
                SizedBox(width: 12),
                Expanded(child: _financialSummaryElement(_presenter.getOverduePayablesDetails())),
              ],
            ),
          ],
        ),
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
