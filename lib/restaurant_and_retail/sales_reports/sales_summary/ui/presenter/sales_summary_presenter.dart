import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';

import '../../../../../_shared/exceptions/wp_exception.dart';
import '../../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../entities/sales_summary.dart';
import '../../entities/sales_summary_details.dart';
import '../../services/sales_summary_provider.dart';
import '../view_contracts/sales_summary_view.dart';

class SalesSummaryPresenter {
  final SalesSummaryView _view;
  final SalesSummaryProvider _itemSalesDataProvider;
  final SelectedCompanyProvider _selectedCompanyProvider;
  late SalesSummary salesSummary;
  DateRange dateFilters = DateRange();

  SalesSummaryPresenter(this._view)
      : _itemSalesDataProvider = SalesSummaryProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  SalesSummaryPresenter.initWith(
    this._view,
    this._itemSalesDataProvider,
    this._selectedCompanyProvider,
  );

  // MARK: Function to load summary data

  loadSalesSummaryData() async {
    if (_itemSalesDataProvider.isLoading) return;

    _view.showLoader();
    try {
      salesSummary = await _itemSalesDataProvider.getSummarySales(dateFilters);
      _view.onDidLoadReport();
    } on WPException catch (e) {
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
    }
  }

  // MARK: Function to apply Filters

  void onFiltersGotClicked() {
    _view.showSalesSummaryFilter();
  }

  Future applyFilters(DateRange? newFilters) async {
    if (newFilters == null) return;
    if (newFilters.startDate.toIso8601String() != dateFilters.startDate.toIso8601String() ||
        newFilters.endDate.toIso8601String() != dateFilters.endDate.toIso8601String()) {
      dateFilters = newFilters;
      await loadSalesSummaryData();
    }
  }

  Future resetFilters() async {
    dateFilters = DateRange();
    await loadSalesSummaryData();
  }

  // MARK: expand and un expand ui

  bool _isCollectionExpanded = true;

  bool get isCollectionsExpanded => _isCollectionExpanded;

  bool _isOrderTypesExpanded = true;

  bool get isOrderTypesExpanded => _isOrderTypesExpanded;

  bool _isCategoriesExpanded = true;

  bool get isCategoriesExpanded => _isCategoriesExpanded;

  bool _isSummaryExpanded = true;

  bool get isSummaryExpanded => _isSummaryExpanded;

  void toggleExpansion(index, isExpanded) {
    switch (index) {
      case 0:
        _isCollectionExpanded = !isExpanded;
        return;
      case 1:
        _isOrderTypesExpanded = !isExpanded;
        return;
      case 2:
        _isCategoriesExpanded = !isExpanded;
        return;
      case 3:
        _isSummaryExpanded = !isExpanded;
        return;
    }
  }

  // MARK: getters

  bool get isSalesSummaryHasDetails =>
      salesSummary.details.categories.isNotEmpty ||
      salesSummary.details.collections.isNotEmpty ||
      salesSummary.details.orderTypes.isNotEmpty;

  bool get isSalesSummaryCollectionsHasData => salesSummary.details.collections.isNotEmpty;

  bool get isSalesSummaryOrderTypeHasData => salesSummary.details.orderTypes.isNotEmpty;

  bool get isSalesSummaryCategoriesHasData => salesSummary.details.categories.isNotEmpty;

  List<SalesSummaryItem> get getSalesSummaryCollections => salesSummary.details.collections;

  List<SaleSummaryOrderType> get getSalesSummaryOrderTypes => salesSummary.details.orderTypes;

  List<SalesSummaryItem> get getSalesSummaryCategories => salesSummary.details.categories;

  String get getSalesSummaryGross => salesSummary.summary.grossSales;

  String get getSalesSummaryDiscounts => salesSummary.summary.discounts;

  String get getSalesSummaryRefunds => salesSummary.summary.refund;

  String get getSalesSummaryTax => salesSummary.summary.tax;

  String get getSalesSummaryNet => salesSummary.summary.netSales;

  String get getSelectedCompanyName => _selectedCompanyProvider.getSelectedCompanyForCurrentUser().name;

  String getSalesSummaryItemNameAt(int index, List<SalesSummaryItem> summaryItem) => summaryItem[index].item;

  String getSalesSummaryItemQuantityAt(int index, List<SalesSummaryItem> collectionsAndCategories) =>
      collectionsAndCategories[index].quantity;

  String getSalesSummaryItemRevenueAt(int index, List<SalesSummaryItem> collectionsAndCategories) =>
      collectionsAndCategories[index].amount;

  String getOrderTypeNameAt(int index) => salesSummary.details.orderTypes[index].item;

  String orderTypePercentageAt(int index) => salesSummary.details.orderTypes[index].percent;

  String orderTypeRevenueAt(int index) => salesSummary.details.orderTypes[index].totalSales;
}
