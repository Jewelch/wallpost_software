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
        ProfitLossWidgetItem(presenter.balanceSheetReport.liabilities),
        _ProfitHeaderDivider(),
        ProfitLossWidgetItem(presenter.balanceSheetReport.equity, isProfit: true),
        _ProfitHeaderDivider(),
        _AmountItem(presenter.balanceSheetReport.totalAssets),
        _ProfitHeaderDivider(),
        _AmountItem(presenter.balanceSheetReport.totalLiabilityAndOwnersEquity, isProfit: true),
        _ProfitHeaderDivider(),
        _AmountItem(presenter.balanceSheetReport.profitLossAccount),
        _AmountItem(presenter.balanceSheetReport.difference),
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
  final AmountModel profitLossItem;
  final bool isProfit;

  const _AmountItem(
    this.profitLossItem, {
    this.isProfit = false,
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
        trailing: Text(profitLossItem.amount),
        title: Text(profitLossItem.name),
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







//   final BalanceSheetPresenter _presenter;

//   BalanceSheetList(this._presenter);

//   @override
//   Widget build(BuildContext context) {
//     final BalanceSheetData balanceSheetData = _presenter.balanceSheetData!;

//     return ListView(
//       padding: EdgeInsets.only(top: 24, bottom: 40),
//       physics: NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       children: [
//         ListTile(
//           title: Text('Assets'),
//           subtitle: _buildSheetDetails(balanceSheetData.assets),
//         ),
//         ListTile(
//           title: Text('Liabilities'),
//           subtitle: _buildSheetDetails(balanceSheetData.liabilities),
//         ),
//         ListTile(
//           title: Text('Equity'),
//           subtitle: _buildSheetDetails(balanceSheetData.equity),
//         ),
//         ListTile(
//           title: Text('Total Assets'),
//           subtitle: _buildAmount(balanceSheetData.totalAssets),
//         ),
//         ListTile(
//           title: Text('Total Liability and Owners Equity'),
//           subtitle: _buildAmount(balanceSheetData.totalLiabilityAndOwnersEquity),
//         ),
//         ListTile(
//           title: Text('Profit & Loss Account'),
//           subtitle: _buildAmount(balanceSheetData.profitLossAccount),
//         ),
//         ListTile(
//           title: Text('Difference'),
//           subtitle: _buildAmount(balanceSheetData.difference),
//         ),
//       ],
//     );
//   }

//   List<Widget> _buildChildrenExpansionTiles(List<SheetDetailsModel> children) {
//     return children.map((child) {
//       return ExpansionTile(
//         title: Text(child.name ?? ''),
//         children: [
//           ListTile(title: Text('Group Name: ${child.groupName ?? ''}')),
//           ListTile(title: Text('Amount: ${child.amount ?? ''}')),
//           if (child.children != null && child.children!.isNotEmpty) ..._buildChildrenExpansionTiles(child.children!),
//         ],
//       );
//     }).toList();
//   }

//   Widget _buildSheetDetails(SheetDetailsModel? sheetDetails) {
//     if (sheetDetails != null) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Name: ${sheetDetails.name ?? ''}'),
//           if (sheetDetails.children != null && sheetDetails.children!.isNotEmpty)
//             ..._buildChildrenExpansionTiles(sheetDetails.children!),
//         ],
//       );
//     } else {
//       return Text('N/A');
//     }
//   }

//   Widget _buildAmount(AmountModel? amountModel) {
//     if (amountModel != null) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Name: ${amountModel.name ?? ''}'),
//           Text('Amount: ${amountModel.amount ?? ''}'),
//         ],
//       );
//     } else {
//       return Text('N/A');
//     }
//   }
// }
