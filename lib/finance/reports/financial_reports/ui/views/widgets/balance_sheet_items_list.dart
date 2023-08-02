import 'package:flutter/material.dart';

import '../../../entities/balance_sheet_data.dart';
import '../../presenters/balance_sheet_presenter.dart';

class BalanceSheetList extends StatelessWidget {
  final BalanceSheetPresenter _presenter;

  BalanceSheetList(this._presenter);

  @override
  Widget build(BuildContext context) {
    final BalanceSheetData balanceSheetData = _presenter.balanceSheetData!;

    return ListView(
      padding: EdgeInsets.only(top: 24, bottom: 40),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        ListTile(
          title: Text('Assets'),
          subtitle: _buildSheetDetails(balanceSheetData.assets),
        ),
        ListTile(
          title: Text('Liabilities'),
          subtitle: _buildSheetDetails(balanceSheetData.liabilities),
        ),
        ListTile(
          title: Text('Equity'),
          subtitle: _buildSheetDetails(balanceSheetData.equity),
        ),
        ListTile(
          title: Text('Total Assets'),
          subtitle: _buildAmount(balanceSheetData.totalAssets),
        ),
        ListTile(
          title: Text('Total Liability and Owners Equity'),
          subtitle: _buildAmount(balanceSheetData.totalLiabilityAndOwnersEquity),
        ),
        ListTile(
          title: Text('Profit & Loss Account'),
          subtitle: _buildAmount(balanceSheetData.profitLossAccount),
        ),
        ListTile(
          title: Text('Difference'),
          subtitle: _buildAmount(balanceSheetData.difference),
        ),
      ],
    );
  }

  List<Widget> _buildChildrenExpansionTiles(List<SheetDetailsModel> children) {
    return children.map((child) {
      return ExpansionTile(
        title: Text(child.name ?? ''),
        children: [
          ListTile(title: Text('Group Name: ${child.groupName ?? ''}')),
          ListTile(title: Text('Amount: ${child.amount ?? ''}')),
          if (child.children != null && child.children!.isNotEmpty) ..._buildChildrenExpansionTiles(child.children!),
        ],
      );
    }).toList();
  }

  Widget _buildSheetDetails(SheetDetailsModel? sheetDetails) {
    if (sheetDetails != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${sheetDetails.name ?? ''}'),
          if (sheetDetails.children != null && sheetDetails.children!.isNotEmpty)
            ..._buildChildrenExpansionTiles(sheetDetails.children!),
        ],
      );
    } else {
      return Text('N/A');
    }
  }

  Widget _buildAmount(AmountModel? amountModel) {
    if (amountModel != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${amountModel.name ?? ''}'),
          Text('Amount: ${amountModel.amount ?? ''}'),
        ],
      );
    } else {
      return Text('N/A');
    }
  }
}
