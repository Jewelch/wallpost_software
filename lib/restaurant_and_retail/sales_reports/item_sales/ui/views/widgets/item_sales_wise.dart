import 'package:flutter/material.dart';

import '../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../_shared/constants/app_colors.dart';
import '../../../entities/sales_item_view_options.dart';
import '../../presenter/item_sales_presenter.dart';
import 'item_sales_category_card_view.dart';
import 'item_sales_category_item_view_card.dart';
import 'item_sales_item_view_card.dart';

class ItemSalesWise extends StatefulWidget {
  const ItemSalesWise(
    this.presenter, {
    super.key,
  });

  final ItemSalesPresenter presenter;

  @override
  State<ItemSalesWise> createState() => _ItemSalesWiseState();
}

class _ItemSalesWiseState extends State<ItemSalesWise> {
  @override
  Widget build(BuildContext context) {
    switch (widget.presenter.filters.salesItemWiseOptions) {
      case SalesItemWiseOptions.CategoriesAndItems:
        return CategoriesAndItemsView(widget.presenter);

      case SalesItemWiseOptions.itemsOnly:
        return ItemsView(widget.presenter);

      case SalesItemWiseOptions.CategoriesOnly:
        return CategoriesView(widget.presenter);
    }
  }
}

class CategoriesView extends StatefulWidget {
  const CategoriesView(
    this.presenter, {
    super.key,
  });

  final ItemSalesPresenter presenter;

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
        dividerColor: Colors.transparent,
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (index, isExpanded) => setState(() => _isExpanded = !isExpanded),
        children: [
          ExpansionPanel(
            backgroundColor: AppColors.screenBackgroundColor2,
            isExpanded: _isExpanded,
            canTapOnHeader: true,
            headerBuilder: ((context, isExpanded) => _ExpansionPanelHeader(
                  widget.presenter.getCategoryCardHeader(),
                  widget.presenter.getTotalRevenue(),
                )),
            body: ItemSalesCategoryViewCard(widget.presenter),
          )
        ]);
  }
}

class ItemsView extends StatefulWidget {
  const ItemsView(
    this.presenter, {
    super.key,
  });

  final ItemSalesPresenter presenter;

  @override
  State<ItemsView> createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (_, isExpanded) => setState(() => _isExpanded = !isExpanded),
        children: [
          ExpansionPanel(
            backgroundColor: AppColors.screenBackgroundColor2,
            isExpanded: _isExpanded,
            canTapOnHeader: true,
            headerBuilder: ((_, isExpanded) => _ExpansionPanelHeader(
                  widget.presenter.getItemCardHeader(),
                  widget.presenter.getTotalRevenue(),
                )),
            body: ItemSalesItemViewCard(widget.presenter),
          )
        ]);
  }
}

class CategoriesAndItemsView extends StatefulWidget {
  const CategoriesAndItemsView(
    this.presenter, {
    super.key,
  });

  final ItemSalesPresenter presenter;

  @override
  State<CategoriesAndItemsView> createState() => _CategoriesAndItemsViewState();
}

class _CategoriesAndItemsViewState extends State<CategoriesAndItemsView> {
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      elevation: 0,
      dividerColor: Colors.transparent,
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (index, isExpanded) =>
          setState(() => widget.presenter.toggleCategoryExpansionStatusAtIndex(index)),
      children: widget.presenter
          .getItemSalesBreakDownList()
          .map(
            (breakDown) => ExpansionPanel(
              backgroundColor: AppColors.screenBackgroundColor2,
              isExpanded: breakDown.isExpanded,
              canTapOnHeader: true,
              headerBuilder: ((_, __) => _ExpansionPanelHeader(
                    widget.presenter.getCategoryNameCardHeader(breakDown),
                    widget.presenter.getBreakDownRevenueForCategory(breakDown),
                  )),
              body: ItemSalesCategoryItemViewCard(widget.presenter, breakDown),
            ),
          )
          .toList(),
    );
  }
}

class _ExpansionPanelHeader extends StatelessWidget {
  final String title;
  final String totalRevenue;

  const _ExpansionPanelHeader(
    this.title,
    this.totalRevenue,
  );

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
            totalRevenue.toString(),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.largeTitleTextStyleBold.copyWith(fontSize: 20.0),
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
