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
    print(profitLossItem.amount);
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        trailing: profitLossItem.children.isEmpty ? SizedBox(width: 24) : null,
        title: _ExpansionPanelHeader(profitLossItem, considerColors: isColored),
        backgroundColor: AppColors.screenBackgroundColor2,
        children: profitLossItem.children.isEmpty
            ? []
            : [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ProfitsLossesChildrenCard(profitLossItem, isColored: isColored),
                )
              ],
      ),
    );
  }
}

class _ExpansionPanelHeader extends StatelessWidget {
  final ProfitLossItem item;
  final bool considerColors;

  const _ExpansionPanelHeader(this.item, {required this.considerColors});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text(
                item.name,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.largeTitleTextStyleBold.copyWith(fontSize: 20.0, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(width: 10),
          Text(
            item.amount,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.largeTitleTextStyleBold.copyWith(
                fontSize: 20.0,
                color: considerColors
                    ? (item.formattedAmount >= 0
                        ? item.formattedAmount > 0
                            ? AppColors.brightGreen
                            : AppColors.textColorBlack
                        : AppColors.red)
                    : AppColors.textColorBlack),
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
