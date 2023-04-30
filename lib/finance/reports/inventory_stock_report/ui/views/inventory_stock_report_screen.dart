import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:notifiable/notifiable.dart';
import 'package:wallpost/_common_widgets/keyboard_dismisser/on_tap_keyboard_dismisser.dart';
import 'package:wallpost/_common_widgets/search_bar/search_bar.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/ui/views/stock_report_widget.dart';

import '../../../../../../_shared/constants/app_colors.dart';
import '../../../../../_common_widgets/app_bars/company_name_app_bar.dart';
import '../../../../../_common_widgets/app_bars/report_title_bar.dart';
import '../../../../../_common_widgets/app_bars/sliver_app_bar_delegate.dart';
import '../../../../../_common_widgets/filter_views/filters_bar.dart';
import '../presenters/inventory_stock_report_presenter.dart';
import '../view_contracts/inventory_stock_report_view.dart';
import 'filter_views/inventory_stock_report_filters_screen.dart';
import 'inventory_stock_loader.dart';
import 'inventory_stock_report_error_widget.dart';

enum _ScreenStates { loading, error, data }

class InventoryStockReportScreen extends StatefulWidget {
  @override
  State<InventoryStockReportScreen> createState() => _State();
}

class _State extends State<InventoryStockReportScreen> implements InventoryStockReportView {
  late InventoryStockReportPresenter _presenter = InventoryStockReportPresenter(this);
  final _screenStateNotifier = ItemNotifier<_ScreenStates>(defaultValue: _ScreenStates.loading);
  final _dataStateNotifier = ItemNotifier<_ScreenStates>(defaultValue: _ScreenStates.loading);
  final _filtersBarUpdateNotifier = Notifier();
  final _listUpdateNotifier = Notifier();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _presenter.loadData();
    _setupScrollDownToLoadMoreItems();
  }

  void _setupScrollDownToLoadMoreItems() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _presenter.getNext();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OnTapKeyboardDismisser(
      dismissOnTap: true,
      dismissOnScroll: true,
      child: Scaffold(
        backgroundColor: AppColors.screenBackgroundColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            color: AppColors.screenBackgroundColor2,
            child: ItemNotifiable<_ScreenStates>(
              notifier: _screenStateNotifier,
              builder: (_, currentState) {
                switch (currentState) {
                  //$ LOADING STATE
                  case _ScreenStates.loading:
                    return ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        CompanyNameAppBar(_presenter.getCompanyName()),
                        InventoryStockLoaderTop(),
                        InventoryStockLoaderBottom(),
                      ],
                    );

                  //! ERROR STATE
                  case _ScreenStates.error:
                    return Column(
                      children: [
                        CompanyNameAppBar(_presenter.getCompanyName()),
                        Expanded(
                          child: InventoryStockReportErrorWidget(
                            errorMessage: _presenter.errorMessage,
                            onRetryButtonPressed: () => _presenter.loadData(),
                          ),
                        ),
                      ],
                    );

                  //* DATA STATE
                  case _ScreenStates.data:
                    return RefreshIndicator(
                      edgeOffset: 216,
                      onRefresh: () {
                        _presenter.refreshWithUpdatedFilters();
                        return Future.value(false);
                      },
                      child: _dataView(),
                    );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _dataView() {
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      slivers: [
        SliverPersistentHeader(
          pinned: false,
          floating: true,
          delegate: SliverAppBarDelegate(
            minHeight: 108,
            maxHeight: 108,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  CompanyNameAppBar(_presenter.getCompanyName()),
                  ReportTitleBar(title: "Inventory Stock", subtitle: "Finance/Reports")
                ],
              ),
            ),
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: SliverAppBarDelegate(
            minHeight: 106,
            maxHeight: 106,
            child: Column(
              children: [
                Notifiable(
                  notifier: _filtersBarUpdateNotifier,
                  builder: (_) {
                    return FiltersBar(
                      items: [
                        FilterBarItem(
                          title: _presenter.copyOfCurrentFilters.getDateFilterTitle(),
                          showClearButton: _presenter.showClearDateFilterIcon(),
                        ),
                        FilterBarItem(
                          title: _presenter.copyOfCurrentFilters.getWarehouseFilterTitle(),
                          showClearButton: _presenter.showClearWarehouseFilterIcon(),
                        ),
                      ],
                      onFilterPressed: (index) {
                        InventoryStockReportFiltersScreen.show(context: context, presenter: _presenter);
                      },
                      onFilterCleared: (index) {
                        if (index == 0) {
                          _presenter.clearDateFilter();
                        } else if (index == 1) {
                          _presenter.clearWarehouseFilter();
                        }
                      },
                      trailingButton: FilterBarItem(title: "Clear", showBorder: false),
                      onTrailingButtonPressed: () => _presenter.clearAllFilterBarFilters(),
                    );
                  },
                ),
                Container(
                  height: 58,
                  padding: EdgeInsets.only(left: 6, right: 6, top: 2, bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: SearchBar(
                    hint: 'Search',
                    onSearchTextChanged: (searchText) => _presenter.setSearchText(searchText),
                    autoFocus: false,
                  ),
                )
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: ItemNotifiable<_ScreenStates>(
            notifier: _dataStateNotifier,
            builder: (_, currentState) {
              switch (currentState) {
                //$ LOADING STATE
                case _ScreenStates.loading:
                  return InventoryStockLoaderBottom();

                //! ERROR STATE
                case _ScreenStates.error:
                  return Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: InventoryStockReportErrorWidget(
                      errorMessage: _presenter.errorMessage,
                      onRetryButtonPressed: () => _presenter.refreshWithUpdatedFilters(),
                    ),
                  );

                //* DATA STATE
                case _ScreenStates.data:
                  return Notifiable(
                    notifier: _listUpdateNotifier,
                    builder: (_) => StockReportWidget(_presenter),
                  );
              }
            },
          ),
        ),
      ],
    );
  }

  //MARK: View functions

  @override
  void showLoader() {
    _screenStateNotifier.notify(_ScreenStates.loading);
  }

  @override
  void onDidFailToLoadAnyData() {
    _screenStateNotifier.notify(_ScreenStates.error);
  }

  @override
  void onDidLoadData() {
    _screenStateNotifier.notify(_ScreenStates.data);
    _dataStateNotifier.notify(_ScreenStates.data);
  }

  @override
  void showGetNextDataLoader() {
    _listUpdateNotifier.notify();
  }

  @override
  void onDidLoadNextData() {
    _listUpdateNotifier.notify();
  }

  @override
  void onDidFailToGetNextData() {
    _listUpdateNotifier.notify();
  }

  @override
  void showFilteringInProgressLoader() {
    _dataStateNotifier.notify(_ScreenStates.loading);
    _filtersBarUpdateNotifier.notify();
  }

  @override
  void onDidFailToApplyFilters() {
    _dataStateNotifier.notify(_ScreenStates.error);
  }

  @override
  void onDidApplyFiltersSuccessfully() {
    _dataStateNotifier.notify(_ScreenStates.data);
  }
}
