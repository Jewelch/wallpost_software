import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_wp_core/company_management/entities/financial_summary.dart';
import 'package:wallpost/dashboard/finance_detail_views/ui/models/finance_detail.dart';

import '../presenters/finance_detail_list_item_presenter.dart';

class FinanceDetailListItem extends StatelessWidget {
  final FinanceDetailListItemPresenter _presenter;

  FinanceDetailListItem(FinancialSummary financialSummary)
      : _presenter = FinanceDetailListItemPresenter(financialSummary);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: _tile(
            _presenter.getProfitLossDetails(),
            _presenter.getOverdueReceivablesDetails(),
          ),
        ),
        Expanded(
          child: _tile(
            _presenter.getAvailableFundsDetails(),
            _presenter.getOverduePayablesDetails(),
          ),
        ),
      ],
    );
  }

  Widget _tile(FinanceDetail topFinanceDetail, FinanceDetail bottomFinanceDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        tileDetails(topFinanceDetail),
        SizedBox(height: 8),
        tileDetails(bottomFinanceDetail),
      ],
    );
  }

  Widget tileDetails(FinanceDetail financeDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          financeDetail.value,
          style: TextStyles.titleTextStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: financeDetail.valueColor,
          ),
        ),
        Text(financeDetail.label, style: TextStyles.smallLabelTextStyle.copyWith(color: Colors.black)),
      ],
    );
  }
}
