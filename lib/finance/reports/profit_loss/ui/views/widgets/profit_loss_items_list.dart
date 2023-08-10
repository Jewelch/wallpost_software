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
        ProfitLossWidgetItem(presenter.profitLossReport.revenue),
        _ProfitHeaderDivider(),
        ProfitLossWidgetItem(presenter.profitLossReport.costOfSales),
        _ProfitHeaderDivider(),
        ProfitLossWidgetItem(presenter.profitLossReport.grossProfit, isProfit: true),
        _ProfitHeaderDivider(),
        ProfitLossWidgetItem(presenter.profitLossReport.expense),
        _ProfitHeaderDivider(),
        ProfitLossWidgetItem(presenter.profitLossReport.operatingProfit, isProfit: true),
        _ProfitHeaderDivider(),
        ProfitLossWidgetItem(presenter.profitLossReport.otherExpenses),
        _ProfitHeaderDivider(),
        ProfitLossWidgetItem(presenter.profitLossReport.otherRevenues),
        _ProfitHeaderDivider(),
        ProfitLossWidgetItem(presenter.profitLossReport.netProfit, isProfit: true),
        _ProfitHeaderDivider(),
      ],
    );
  }
}

class _ProfitHeaderDivider extends StatelessWidget {
  const _ProfitHeaderDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Divider(height: 2),
    );
  }
}

class ProfitLossWidgetItem extends StatelessWidget {
  final ProfitLossItem profitLossItem;
  final bool isProfit;

  const ProfitLossWidgetItem(
    this.profitLossItem, {
    this.isProfit = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        childrenPadding: EdgeInsets.zero,
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        tilePadding: EdgeInsets.symmetric(horizontal: 24),
        trailing: profitLossItem.children.isEmpty ? SizedBox.shrink() : null,
        title: _ExpansionPanelHeader(profitLossItem, isProfit: isProfit),
        children: profitLossItem.children.isEmpty
            ? []
            : [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ProfitsLossesChildrenCard(profitLossItem, isParent: true),
                )
              ],
      ),
    );
  }
}

class _ExpansionPanelHeader extends StatelessWidget {
  final ProfitLossItem item;
  final bool isProfit;

  const _ExpansionPanelHeader(this.item, {required this.isProfit});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Text(
              isProfit ? item.exactName : item.name,
              maxLines: 3,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: isProfit
                  ? TextStyles.largeTitleTextStyleBold.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textColorBlueGrayLight,
                    )
                  : TextStyles.largeTitleTextStyleBold.copyWith(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                    ),
            ),
          ),
          Text(
            item.amount,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.largeTitleTextStyleBold.copyWith(
                fontSize: 18.0,
                color: isProfit
                    ? (item.formattedAmount >= 0
                        ? item.formattedAmount > 0
                            ? AppColors.brightGreen
                            : AppColors.textColorBlack
                        : AppColors.red)
                    : AppColors.textColorBlack),
          ),
        ],
      ),
    );
  }
}
