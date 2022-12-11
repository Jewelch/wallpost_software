import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:notifiable/notifiable.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/ui/presenter/item_sales_presenter.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/ui/view_contracts/item_sales_view.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/views/widgets/sliver_sales_breakdowns_horizontal_list.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/ui/views/loader/item_sales_loader.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/ui/views/loader/item_wise_loader.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/ui/views/widgets/item_sales_error_view.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/ui/views/widgets/item_sales_header_card.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/ui/views/widgets/item_sales_wise.dart';

import '../widgets/item_sales_app_bar.dart';

enum _ScreenStates { loading, error, data }

enum _SalesItemWiseStates { loading, error, data, noData }

class ItemSalesScreen extends StatefulWidget {
  const ItemSalesScreen({super.key});

  @override
  State<ItemSalesScreen> createState() => _State();
}

class _State extends State<ItemSalesScreen> implements ItemSalesView {
  late ItemSalesPresenter _presenter = ItemSalesPresenter(this);
  bool _isExpanded = false;
  final salesItemWiseStateNotifier = ItemNotifier<_SalesItemWiseStates>(defaultValue: _SalesItemWiseStates.loading);
  final screenStateNotifier = ItemNotifier<_ScreenStates>(defaultValue: _ScreenStates.loading);
  final salesItemDataNotifier = Notifier();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadItemSalesData();
  }

  void _loadItemSalesData() => _presenter.loadItemSalesData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      body: ItemNotifiable<_ScreenStates>(
        notifier: screenStateNotifier,
        builder: (_, currentState) {
          switch (currentState) {
            // $ LOADING STATE
            case _ScreenStates.loading:
              return ItemSalesLoader();

            //! ERROR STATE
            case _ScreenStates.error:
              return SalesItemErrorView(
                errorMessage: errorMessage,
                onRetry: _loadItemSalesData,
              );

            // //* DATA STATE
            case _ScreenStates.data:
              return _dataView();

            //_dataView();
          }
        },
      ),
    );
  }

  Widget _dataView() {
    return SafeArea(
      child: Container(
        color: AppColors.screenBackgroundColor2,
        child: CustomScrollView(
          slivers: [
            MultiSliver(
              children: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverAppBarDelegate(
                    minHeight: 155,
                    maxHeight: 155,
                    child: ItemSalesAppBar(_presenter),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 30),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverAppBarDelegate(
                    minHeight: 90,
                    maxHeight: 200,
                    child: Notifiable(
                      notifier: salesItemDataNotifier,
                      builder: (context) => LayoutBuilder(
                          builder: (context, contraints) => Padding(
                                padding: contraints.maxHeight > 150 ? EdgeInsets.symmetric(horizontal: 24) : EdgeInsets.zero,
                                child: ItemSalesHeaderCard(_presenter, contraints.maxHeight),
                              )),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 16),
                ),

                // SliverSalesBreakHorizontalList(
                //   presenter: _presenter,
                // ),
                _salesBreakdownViews(),

                SliverToBoxAdapter(
                  child: SizedBox(height: 16),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _salesBreakdownViews() {
    return ItemNotifiable<_SalesItemWiseStates>(
      notifier: salesItemWiseStateNotifier,
      builder: (_, currentState) {
        switch (currentState) {
          //   //* LOADING STATE
          case _SalesItemWiseStates.loading:
            return SliverToBoxAdapter(child: ItemWiseLoader());

          //   // //! ERROR STATE
          case _SalesItemWiseStates.error:
            return MultiSliver(
              children: [
                SliverToBoxAdapter(
                  child: Container(
                    child: TextButton(
                      child: Text(
                        errorMessage,
                        textAlign: TextAlign.center,
                        style: TextStyles.titleTextStyle,
                      ),
                      onPressed: _loadItemSalesData,
                    ),
                  ),
                ),
              ],
            );

          //   //* DATA STATE
          case _SalesItemWiseStates.data:
            return SliverToBoxAdapter(
              child: ItemSalesWise(_presenter),
            );

          //* NO DATA STATE
          default:
            return SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    Text(
                      "There is no sales item for\nthe selected filters",
                      textAlign: TextAlign.center,
                      style: TextStyles.titleTextStyle,
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }

  @override
  void showLoader() => screenStateNotifier.notify(_ScreenStates.loading);

  @override
  void showSalesReportFilter() {}
  @override
  void onDidChangeSalesItemWise() => _presenter.loadItemSalesData();
  @override
  void showLoadingForSalesItemsWise() => salesItemWiseStateNotifier.notify(_SalesItemWiseStates.loading);

  @override
  void showSalesBreakDowns() {
    screenStateNotifier.notify(_ScreenStates.data);
    salesItemWiseStateNotifier.notify(_SalesItemWiseStates.data);
  }

  @override
  void showErrorMessage(String message) {
    this.errorMessage = errorMessage;
    screenStateNotifier.notify(_ScreenStates.error);
  }

  @override
  void updateSalesItemData() => screenStateNotifier.notify(_ScreenStates.data);

  @override
  void showNoSalesBreakdownMessage() {
    screenStateNotifier.notify(_ScreenStates.data);
    salesItemWiseStateNotifier.notify(_SalesItemWiseStates.noData);
  }
}
