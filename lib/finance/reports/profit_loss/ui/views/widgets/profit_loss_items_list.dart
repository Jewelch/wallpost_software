import 'package:flutter/material.dart';
import 'package:wallpost/finance/reports/profit_loss/entities/profit_loss_model.dart';

import '../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../_shared/constants/app_colors.dart';
import '../../presenter/profit_loss_presenter.dart';
import 'profit_loss_children_item_view_card.dart';

class ProfitsLossesExpansions extends StatelessWidget {
  const ProfitsLossesExpansions(
    this.presenter, {
    super.key,
  });

  final ProfitsLossesPresenter presenter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfitLossWidgetItem(presenter.profitLossReport.revenue, isColored: true),
        ProfitLossWidgetItem(presenter.profitLossReport.costOfSales),
        ProfitLossWidgetItem(presenter.profitLossReport.grossProfit, isColored: true),
        ProfitLossWidgetItem(presenter.profitLossReport.expense),
        ProfitLossWidgetItem(presenter.profitLossReport.operatingProfit),
        ProfitLossWidgetItem(presenter.profitLossReport.otherExpenses),
        ProfitLossWidgetItem(presenter.profitLossReport.otherRevenues),
        ProfitLossWidgetItem(presenter.profitLossReport.netProfit, isColored: true),
      ],
    );
  }
}

class ProfitLossWidgetItem extends StatelessWidget {
  final ProfitLossItem profitLossItem;
  final bool isColored;

  const ProfitLossWidgetItem(
    this.profitLossItem, {
    this.isColored = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      trailing: profitLossItem.children.isEmpty ? SizedBox(width: 24) : null,
      title: _ExpansionPanelHeader(profitLossItem.name, profitLossItem.amount, considerColors: isColored),
      backgroundColor: AppColors.screenBackgroundColor2,
      children: [ProfitsLossesChildrenCard(profitLossItem, isColored: isColored)],
    );
  }
}

class _ExpansionPanelHeader extends StatelessWidget {
  final String title;
  final String amount;
  final bool considerColors;

  const _ExpansionPanelHeader(this.title, this.amount, {required this.considerColors});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text(
                title,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.largeTitleTextStyleBold.copyWith(fontSize: 20.0, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(width: 10),
          Text(
            amount.toString(),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.largeTitleTextStyleBold.copyWith(
                fontSize: 20.0,
                color: considerColors
                    ? (num.parse(amount) >= 0
                        ? num.parse(amount) > 0
                            ? Colors.green
                            : Colors.black
                        : Colors.red)
                    : Colors.black),
          ),
          SizedBox(width: 2),
          Align(
              heightFactor: 1.5,
              alignment: Alignment.topLeft,
              child: Text(
                "QAR",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppColors.textColorBlueGray,
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                ),
              )),
        ],
      ),
    );
  }
}
