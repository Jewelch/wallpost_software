import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/containers/elevated_container.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/ui/presenters/inventory_stock_report_presenter.dart';

import '../../../../../_common_widgets/containers/performance_container.dart';
import '../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../_shared/constants/app_colors.dart';
import '../../entities/inventory_stock_item.dart';
import '../models/stock_list_item_view_type.dart';

class StockReportWidget extends StatelessWidget {
  final InventoryStockReportPresenter _presenter;

  const StockReportWidget(this._presenter, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedContainer(
          child: PerformanceContainer(
            title: _presenter.getTotalStockValue().value,
            subtitle: _presenter.getTotalStockValue().label,
            titleColor: _presenter.getTotalStockValue().textColor,
            backgroundColor: _presenter.getTotalStockValue().backgroundColor,
            showLargeTitle: true,
          ),
        ),
        ElevatedContainer(
          padding: EdgeInsets.zero,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _presenter.getNumberOfListItems(),
            itemBuilder: (context, index) {
              switch (_presenter.getItemTypeAtIndex(index)) {
                case StockListItemViewType.Header:
                  return _StockListHeader();
                case StockListItemViewType.ListItem:
                  return _StockListItemView(_presenter, _presenter.getItemAtIndex(index));
                case StockListItemViewType.Loader:
                  return Container(
                    height: 56,
                    child: Center(
                      child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator(strokeWidth: 3)),
                    ),
                  );
                case StockListItemViewType.ErrorMessage:
                  return GestureDetector(
                    onTap: () => _presenter.getNext(),
                    child: Container(
                      height: 100,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Center(child: Text(_presenter.errorMessage, textAlign: TextAlign.center)),
                    ),
                  );
                case StockListItemViewType.EmptySpace:
                  return Container();
              }
            },
            separatorBuilder: (_, index) {
              switch (_presenter.getItemTypeAtIndex(index)) {
                case StockListItemViewType.Header:
                  return Container();
                default:
                  return Divider(height: 1);
              }
            },
          ),
        ),
        SizedBox(height: 100),
      ],
    );
  }
}

class _StockListHeader extends StatelessWidget {
  const _StockListHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text("", style: TextStyles.subTitleTextStyle),
          ),
          SizedBox(width: 6),
          Expanded(
            flex: 2,
            child: Text(
              "Avl. qty.",
              style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.textColorBlueGrayLight),
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(width: 6),
          Expanded(
            flex: 2,
            child: Text("Value",
                style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.textColorBlueGrayLight),
                textAlign: TextAlign.right),
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }
}

class _StockListItemView extends StatelessWidget {
  final InventoryStockReportPresenter _presenter;
  final InventoryStockItem _item;

  const _StockListItemView(this._presenter, this._item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Text(_presenter.getTitle(_item), style: TextStyles.titleTextStyle, maxLines: 2),
          ),
          SizedBox(width: 6),
          Expanded(
            flex: 2,
            child: Text(
              _presenter.getTotalQuantity(_item).value,
              style: TextStyles.titleTextStyle.copyWith(color: _presenter.getTotalQuantity(_item).textColor),
              textAlign: TextAlign.end,
              maxLines: 2,
            ),
          ),
          SizedBox(width: 6),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                _presenter.getTotalValue(_item).value,
                style: TextStyles.largeTitleTextStyleBold.copyWith(color: _presenter.getTotalValue(_item).textColor),
                textAlign: TextAlign.end,
                maxLines: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
