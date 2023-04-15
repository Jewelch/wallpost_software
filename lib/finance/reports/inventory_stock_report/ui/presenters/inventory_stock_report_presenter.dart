import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/entities/inventory_stock_item.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/entities/inventory_stock_report.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/entities/inventory_stock_warehouse.dart';

import '../../../../shared_models/performance_value.dart';
import '../../entities/inventory_stock_report_filter.dart';
import '../../services/inventory_stock_report_provider.dart';
import '../models/stock_list_item_view_type.dart';
import '../view_contracts/inventory_stock_report_view.dart';

class InventoryStockReportPresenter {
  InventoryStockReportView _view;
  InventoryStockReportProvider _reportProvider;
  final SelectedCompanyProvider _companyProvider;
  late InventoryStockReport _report;
  String _errorMessage = "";
  final String _noItemsMessage = "There are no inventory stock items to show.\n\n"
      "Try changing the filters or tap here to reload.";

  var _filters = InventoryStockReportFilter();

  InventoryStockReportPresenter(this._view)
      : _reportProvider = InventoryStockReportProvider(),
        _companyProvider = SelectedCompanyProvider();

  InventoryStockReportPresenter.initWith(this._view, this._reportProvider, this._companyProvider);

  /// Call this function to load the data in the screen for the first time

  Future<void> loadData() async {
    if (_reportProvider.isLoading) return;
    _view.showLoader();
    _reportProvider.reset();
    _resetErrors();

    try {
      _report = await _reportProvider.getNext(_filters);
      _view.onDidLoadData();
    } on WPException catch (e) {
      _errorMessage = '${e.userReadableMessage}\n\nTap here to reload.';
      _view.onDidFailToLoadAnyData();
    }
  }

  /// Call this function to load the next set of data when the user
  /// scrolls to the bottom of the list

  Future<void> getNext() async {
    if (_reportProvider.isLoading) return;
    _view.showGetNextDataLoader();
    _resetErrors();

    try {
      _report = await _reportProvider.getNext(_filters);
      _view.onDidLoadNextData();
    } on WPException catch (e) {
      _errorMessage = '${e.userReadableMessage}\n\nTap here to reload.';
      _view.onDidFailToGetNextData();
    }
  }

  /// Call this function to load the data after selecting filters

  Future<void> refreshWithUpdatedFilters() async {
    //we do not return if the provider is loading as the user can quickly change the filters
    //(like search text) and it should reload the data immediately with the updated filters
    _view.showFilteringInProgressLoader();
    _reportProvider.reset();
    _resetErrors();

    try {
      _report = await _reportProvider.getNext(_filters);
      _view.onDidApplyFiltersSuccessfully();
    } on WPException catch (e) {
      _errorMessage = '${e.userReadableMessage}\n\nTap here to reload.';
      _view.onDidFailToApplyFilters();
    }
  }

  void _resetErrors() {
    _errorMessage = "";
  }

  //MARK: Function to apply filters

  Future<void> setFilterBarFilters({required DateTime date, InventoryStockWarehouse? warehouse}) async {
    _filters.date = date;
    _filters.warehouse = warehouse;
    await refreshWithUpdatedFilters();
  }

  Future<void> setSearchText(String searchText) async {
    _filters.searchText = searchText;
    await refreshWithUpdatedFilters();
  }

  Future<void> updateFilters(InventoryStockReportFilter newFilters) async {
    _filters = newFilters;
    await refreshWithUpdatedFilters();
  }

  //MARK: Function to clear filters

  bool showClearDateFilterIcon() {
    if (_filters.date.isToday()) {
      return false;
    } else {
      return true;
    }
  }

  bool showClearWarehouseFilterIcon() {
    if (_filters.warehouse == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> clearDateFilter() async {
    _filters.date = DateTime.now();
    await refreshWithUpdatedFilters();
  }

  Future<void> clearWarehouseFilter() async {
    _filters.warehouse = null;
    await refreshWithUpdatedFilters();
  }

  Future<void> clearAllFilterBarFilters() async {
    _filters.date = DateTime.now();
    _filters.warehouse = null;
    await refreshWithUpdatedFilters();
  }

  Future<void> clearSearchFilter() async {
    _filters.searchText = "";
    await refreshWithUpdatedFilters();
  }

  //MARK: Functions to get the list details

  int getNumberOfListItems() {
    if (_report.items.length == 0) return 0;
    return _report.items.length + 2;
  }

  StockListItemViewType getItemTypeAtIndex(int index) {
    if (index == 0) return StockListItemViewType.Header;

    if (index <= _report.items.length) return StockListItemViewType.ListItem;

    if (_errorMessage.isNotEmpty) return StockListItemViewType.ErrorMessage;

    if (_reportProvider.isLoading || _reportProvider.didReachListEnd == false) return StockListItemViewType.Loader;

    return StockListItemViewType.EmptySpace;
  }

  InventoryStockItem getItemAtIndex(int index) {
    return _report.items[index - 1];
  }

  //MARK: Header card getters

  PerformanceValue getTotalStockValue() {
    var currency = _companyProvider.getSelectedCompanyForCurrentUser().currency;
    return PerformanceValue(
      label: "Stock Value ($currency)",
      value: _report.total,
      textColor: AppColors.brightGreen,
      backgroundColor: AppColors.lightGreen,
    );
  }

  //MARK: Stock item getters

  String getTitle(InventoryStockItem item) {
    return item.name;
  }

  PerformanceValue getTotalQuantity(InventoryStockItem item) {
    return PerformanceValue(
      label: "",
      value: item.totalQuantity,
      textColor: _getPerformanceColorForItem(item),
      backgroundColor: Colors.white,
    );
  }

  PerformanceValue getTotalValue(InventoryStockItem item) {
    return PerformanceValue(
      label: "",
      value: item.totalValue,
      textColor: _getPerformanceColorForItem(item),
      backgroundColor: Colors.white,
    );
  }

  Color _getPerformanceColorForItem(InventoryStockItem item) {
    if (item.isStockZero()) {
      return AppColors.yellow;
    } else if (item.isStockNegative()) {
      return AppColors.red;
    } else {
      return AppColors.green;
    }
  }

  //MARK: Getters

  String getCompanyName() {
    return _companyProvider.getSelectedCompanyForCurrentUser().name;
  }

  String get errorMessage => _errorMessage;

  String get noItemsMessage => _noItemsMessage;

  InventoryStockReportFilter get copyOfCurrentFilters => _filters.copy();
}
