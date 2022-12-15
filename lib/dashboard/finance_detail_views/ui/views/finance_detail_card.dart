import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/custom_shapes/header_card.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/finance/ui/views/finance_dashboard_screen.dart';

import '../../../../../_wp_core/company_management/entities/financial_summary.dart';
import '../../../../_common_widgets/screen_presenter/screen_presenter.dart';
import '../../../../finance/ui/finance_inner_screen.dart';
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
               /* Text(
                  _presenter.getCurrency(),
                  textAlign: TextAlign.end,
                  style: TextStyles.headerCardSubLabelTextStyle.copyWith(fontSize: 17.0),
                ),*/
                GestureDetector(
                  onTap: () {
                   // ScreenPresenter.present(FinanceInnerScreen() ,context);
                    ScreenPresenter.present(FinanceDashBoardScreen() ,context);
                  },
                  child: Container(
                      height: 14, width: 14, child: SvgPicture.asset('assets/icons/arrow_forward_blue.svg', width: 40, height: 40)),
                ),
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
