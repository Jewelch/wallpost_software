import 'package:flutter/material.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/sales_summary/entities/sales_summary_details.dart';

import '../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../_shared/constants/app_colors.dart';
import '../../presenter/sales_summary_presenter.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView(
    this.presenter, {
    super.key,
  });

  final SalesSummaryPresenter presenter;

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      elevation: 0,
      dividerColor: Colors.transparent,
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (index, isExpanded) {
        widget.presenter.toggleExpansion(index, isExpanded);
        setState(() {});
      },
      children: [
        if (widget.presenter.isSalesSummaryCollectionsHasData)
          ExpansionPanel(
            backgroundColor: AppColors.screenBackgroundColor2,
            isExpanded: widget.presenter.isCollectionsExpanded,
            canTapOnHeader: true,
            headerBuilder: ((_, __) => _ExpansionPanelHeader('Collections')),
            body: _SalesSummaryItemExpansionCard(
              widget.presenter,
              widget.presenter.getSalesSummaryCollections,
              displayQuantities: false,
            ),
          ),
        if (widget.presenter.isSalesSummaryOrderTypeHasData)
          ExpansionPanel(
            backgroundColor: AppColors.screenBackgroundColor2,
            isExpanded: widget.presenter.isOrderTypesExpanded,
            canTapOnHeader: true,
            headerBuilder: ((_, __) => _ExpansionPanelHeader('Order Type')),
            body: _OrderTypesExpansionCard(
              widget.presenter,
              widget.presenter.getSalesSummaryOrderTypes,
            ),
          ),
        if (widget.presenter.isSalesSummaryCategoriesHasData)
          ExpansionPanel(
            backgroundColor: AppColors.screenBackgroundColor2,
            isExpanded: widget.presenter.isCategoriesExpanded,
            canTapOnHeader: true,
            headerBuilder: ((_, __) => _ExpansionPanelHeader('Categories')),
            body: _SalesSummaryItemExpansionCard(
              widget.presenter,
              widget.presenter.getSalesSummaryCategories,
              displayQuantities: true,
            ),
          ),
        if (widget.presenter.isSalesSummaryHasDetails)
          ExpansionPanel(
            backgroundColor: AppColors.screenBackgroundColor2,
            isExpanded: widget.presenter.isSummaryExpanded,
            canTapOnHeader: true,
            headerBuilder: ((_, __) => _ExpansionPanelHeader('Summary')),
            body: _SummaryExpansionCard(widget.presenter),
          ),
      ],
    );
  }
}

class _SummaryExpansionCard extends StatelessWidget {
  final SalesSummaryPresenter presenter;

  const _SummaryExpansionCard(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        borderOnForeground: true,
        elevation: 0,
        child: Column(
          children: [
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Revenue",
                  style: TextStyles.labelTextStyle.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            ListView(
              padding: EdgeInsets.only(top: 6),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _SummaryElement(
                  presenter: presenter,
                  title: 'Gross Sales',
                  value: presenter.getSalesSummaryGross,
                ),
                _SummaryElement(
                  presenter: presenter,
                  title: 'Discount',
                  value: presenter.getSalesSummaryDiscounts,
                ),
                _SummaryElement(
                  presenter: presenter,
                  title: 'Refund',
                  value: presenter.getSalesSummaryRefunds,
                ),
                _SummaryElement(
                  presenter: presenter,
                  title: 'Tax',
                  value: presenter.getSalesSummaryTax,
                ),
                _SummaryElement(
                  presenter: presenter,
                  title: 'Net Sales',
                  value: presenter.getSalesSummaryNet,
                  shouldDisplayDivider: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryElement extends StatelessWidget {
  final SalesSummaryPresenter presenter;

  const _SummaryElement({
    required this.title,
    required this.value,
    required this.presenter,
    this.shouldDisplayDivider = true,
  });

  final String title;
  final String value;
  final bool shouldDisplayDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: AppColors.textColorBlueGray,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
              ),
              Expanded(
                  child: Row(
                children: [
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      value,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.largeTitleTextStyleBold,
                    ),
                  ),
                  SizedBox(width: 3),
                  Column(
                    children: [
                      Text(
                        '${presenter.getCompanyCurrency()}',
                        style: TextStyle(
                          color: AppColors.textColorBlueGray,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 3),
                    ],
                  ),
                ],
              )),
            ],
          ),
        ),
        shouldDisplayDivider ? Divider(height: 1) : SizedBox(),
      ],
    );
  }
}

class _ExpansionPanelHeader extends StatelessWidget {
  final String title;

  const _ExpansionPanelHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.largeTitleTextStyleBold.copyWith(fontSize: 20.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class _SalesSummaryItemExpansionCard extends StatelessWidget {
  final SalesSummaryPresenter presenter;
  final List<SalesSummaryItem> salesSummaryItem;
  final bool displayQuantities;

  const _SalesSummaryItemExpansionCard(
    this.presenter,
    this.salesSummaryItem, {
    required this.displayQuantities,
  });

  @override
  Widget build(BuildContext context) {
    final double itemNameWidth = MediaQuery.of(context).size.width * (displayQuantities ? .32 : .53);
    const double quantityWidth = 70;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        borderOnForeground: true,
        elevation: 0,
        child: Column(
          children: [
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  SizedBox(width: itemNameWidth),
                  if (displayQuantities)
                    SizedBox(
                      width: quantityWidth,
                      child: Text(
                        "Qty.",
                        style: TextStyles.labelTextStyle.copyWith(fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  Spacer(),
                  Text(
                    "Revenue",
                    style: TextStyles.labelTextStyle.copyWith(fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.only(top: 6),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: salesSummaryItem.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: itemNameWidth,
                            child: Text(
                              presenter.getSalesSummaryItemNameAt(index, salesSummaryItem),
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: AppColors.textColorBlueGray,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                            ),
                          ),
                          if (displayQuantities)
                            SizedBox(
                              width: quantityWidth,
                              child: Text(
                                presenter.getSalesSummaryItemQuantityAt(index, salesSummaryItem),
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: AppColors.textColorBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                              ),
                            ),
                          Expanded(
                              child: Row(
                            children: [
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  presenter.getSalesSummaryItemRevenueAt(index, salesSummaryItem),
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles.largeTitleTextStyleBold,
                                ),
                              ),
                              SizedBox(width: 3),
                              Column(
                                children: [
                                  Text(
                                    '${presenter.getCompanyCurrency()}',
                                    style: TextStyle(
                                      color: AppColors.textColorBlueGray,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                ],
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),
                    index < (salesSummaryItem.length) - 1 ? Divider(height: 1) : SizedBox(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderTypesExpansionCard extends StatelessWidget {
  final SalesSummaryPresenter presenter;
  final List<SaleSummaryOrderType> orderTypeList;

  const _OrderTypesExpansionCard(this.presenter, this.orderTypeList);

  @override
  Widget build(BuildContext context) {
    final double itemNameWidth = MediaQuery.of(context).size.width * .32;
    const double quantityWidth = 70;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        borderOnForeground: true,
        elevation: 0,
        child: Column(
          children: [
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  SizedBox(width: itemNameWidth),
                  SizedBox(
                    width: quantityWidth,
                    child: Text(
                      "Per %",
                      style: TextStyles.labelTextStyle.copyWith(fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Revenue",
                    style: TextStyles.labelTextStyle.copyWith(fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.only(top: 6),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: orderTypeList.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: itemNameWidth,
                            child: Text(
                              presenter.getOrderTypeNameAt(index),
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: AppColors.textColorBlueGray,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(
                            width: quantityWidth,
                            child: Text(
                              presenter.orderTypePercentageAt(index),
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: AppColors.textColorBlack,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ),
                          Expanded(
                              child: Row(
                            children: [
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  presenter.orderTypeRevenueAt(index),
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles.largeTitleTextStyleBold,
                                ),
                              ),
                              SizedBox(width: 3),
                              Column(
                                children: [
                                  Text(
                                    '${presenter.getCompanyCurrency()}',
                                    style: TextStyle(
                                      color: AppColors.textColorBlueGray,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                ],
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),
                    index < (orderTypeList.length) - 1 ? Divider(height: 1) : SizedBox(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
