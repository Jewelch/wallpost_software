import 'package:flutter/material.dart';

import '../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../_shared/constants/app_colors.dart';
import '../../../entities/sales_summary_models.dart';
import '../../presenter/sales_summary_presenter.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView(
    this.presenter, {
    super.key,
  });

  final SummarySalesPresenter presenter;

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
        if (widget.presenter.collectionsAvailble)
          ExpansionPanel(
            backgroundColor: AppColors.screenBackgroundColor2,
            isExpanded: widget.presenter.collectionsAreExpanded,
            canTapOnHeader: true,
            headerBuilder: ((_, __) => _ExpansionPanelHeader('Collections')),
            body: CollectionsAndCategoriesExpansionCard(
              widget.presenter,
              widget.presenter.getCollection(),
              displayQuantities: false,
            ),
          ),
        if (widget.presenter.orderTypesAvailble)
          ExpansionPanel(
            backgroundColor: AppColors.screenBackgroundColor2,
            isExpanded: widget.presenter.orderTypesAreExpanded,
            canTapOnHeader: true,
            headerBuilder: ((_, __) => _ExpansionPanelHeader('Order Type')),
            body: _OrderTypesExpansionCard(
              widget.presenter,
              widget.presenter.getOrderTypes(),
            ),
          ),
        if (widget.presenter.categoriesAvailble)
          ExpansionPanel(
            backgroundColor: AppColors.screenBackgroundColor2,
            isExpanded: widget.presenter.categoriesAreExpanded,
            canTapOnHeader: true,
            headerBuilder: ((_, __) => _ExpansionPanelHeader('Categories')),
            body: CollectionsAndCategoriesExpansionCard(
              widget.presenter,
              widget.presenter.getCategories(),
              displayQuantities: true,
            ),
          ),
        if (widget.presenter.summaryAvailble)
          ExpansionPanel(
            backgroundColor: AppColors.screenBackgroundColor2,
            isExpanded: widget.presenter.summaryIsExpanded,
            canTapOnHeader: true,
            headerBuilder: ((_, __) => _ExpansionPanelHeader('Summary')),
            body: SummaryExpansionCard(widget.presenter),
          ),
      ],
    );
  }
}

class SummaryExpansionCard extends StatelessWidget {
  final SummarySalesPresenter presenter;

  const SummaryExpansionCard(this.presenter, {super.key});

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
                SummaryElement(
                  title: 'Gross Sales',
                  value: presenter.summaryGrossSales,
                ),
                SummaryElement(
                  title: 'Discount',
                  value: presenter.summaryDiscounts,
                ),
                SummaryElement(
                  title: 'Refund',
                  value: presenter.summaryRefunds,
                ),
                SummaryElement(
                  title: 'Tax',
                  value: presenter.summaryTax,
                ),
                SummaryElement(
                  title: 'Net Sales',
                  value: presenter.summaryNetSales,
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

class SummaryElement extends StatelessWidget {
  const SummaryElement({
    super.key,
    required this.title,
    required this.value,
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
                        'QAR',
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

class CollectionsAndCategoriesExpansionCard extends StatelessWidget {
  final SummarySalesPresenter presenter;
  final List<CollectionsModel> collectionsAndCategories;
  final bool displayQuantities;

  const CollectionsAndCategoriesExpansionCard(
    this.presenter,
    this.collectionsAndCategories, {
    required this.displayQuantities,
    super.key,
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
              itemCount: presenter.collectionsAndCategoriesLength(collectionsAndCategories),
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
                              presenter.collectionOrCategoryName(index, collectionsAndCategories),
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
                                presenter.collectionOrCategoryQuantity(index, collectionsAndCategories),
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
                                  presenter.collectionOrCategoryRevenue(index, collectionsAndCategories),
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles.largeTitleTextStyleBold,
                                ),
                              ),
                              SizedBox(width: 3),
                              Column(
                                children: [
                                  Text(
                                    'QAR',
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
                    index < (collectionsAndCategories.length) - 1 ? Divider(height: 1) : SizedBox(),
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
  final SummarySalesPresenter presenter;
  final List<OrderTypesModel> collections;

  const _OrderTypesExpansionCard(this.presenter, this.collections);

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
              itemCount: collections.length,
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
                              presenter.orderTypeNameAt(index),
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
                                    'QAR',
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
                    index < (collections.length) - 1 ? Divider(height: 1) : SizedBox(),
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
