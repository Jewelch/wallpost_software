import 'package:flutter/material.dart';

import '../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../_shared/constants/app_colors.dart';
import '../../../entities/balance_sheet_data.dart';
import '../../presenters/balance_sheet_presenter.dart';
import 'balance_sheet_children_item_view_card.dart';

class BalanceSheetList extends StatelessWidget {
  const BalanceSheetList(
    this.presenter, {
    super.key,
  });

  final BalanceSheetPresenter presenter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfitLossWidgetItem(presenter.balanceSheetReport.assets),
        _BalanceSheetHeaderDivider(),
        ProfitLossWidgetItem(presenter.balanceSheetReport.liabilities),
        _BalanceSheetHeaderDivider(),
        ProfitLossWidgetItem(presenter.balanceSheetReport.equity),
        _BalanceSheetHeaderDivider(),
        _AmountItem(presenter.balanceSheetReport.totalAssets),
        _BalanceSheetHeaderDivider(),
        _AmountItem(presenter.balanceSheetReport.totalLiabilityAndOwnersEquity),
        _BalanceSheetHeaderDivider(),
        _AmountItem(presenter.balanceSheetReport.profitLossAccount),
        _BalanceSheetHeaderDivider(),
        _AmountItem(
          presenter.balanceSheetReport.difference,
          isProfit: true,
        ),
        _BalanceSheetHeaderDivider(),
      ],
    );
  }
}

class _BalanceSheetHeaderDivider extends StatelessWidget {
  const _BalanceSheetHeaderDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Divider(height: 8),
    );
  }
}

class ProfitLossWidgetItem extends StatelessWidget {
  final SheetDetailsModel profitLossItem;
  final bool isProfit;

  const ProfitLossWidgetItem(
    this.profitLossItem, {
    this.isProfit = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print(profitLossItem.amount);
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        childrenPadding: EdgeInsets.zero,
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        tilePadding: EdgeInsets.symmetric(horizontal: 24),
        trailing: (profitLossItem.children.isEmpty) ? SizedBox.shrink() : null,
        title: _ExpansionPanelHeader(profitLossItem, isProfit: isProfit),
        children: (profitLossItem.children.isEmpty)
            ? []
            : [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: BalanceSheetChildrenCard(profitLossItem, isParent: true),
                )
              ],
      ),
    );
  }
}

class _AmountItem extends StatelessWidget {
  final AmountModel item;
  final bool isProfit;

  const _AmountItem(
    this.item, {
    this.isProfit = false,
  });

  @override
  Widget build(BuildContext context) {
    print(item.amount);
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        childrenPadding: EdgeInsets.zero,
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        tilePadding: EdgeInsets.symmetric(horizontal: 24),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 40),
          child: Text(
            item.amount,
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
        ),
        title: Text(
          item.name,
          style: TextStyles.largeTitleTextStyleBold.copyWith(
            fontSize: 17.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ExpansionPanelHeader extends StatelessWidget {
  final SheetDetailsModel item;
  final bool isProfit;

  const _ExpansionPanelHeader(this.item, {required this.isProfit});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.name,
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
