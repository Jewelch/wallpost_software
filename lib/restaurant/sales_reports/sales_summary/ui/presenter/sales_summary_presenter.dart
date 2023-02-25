import '../../../../../_shared/exceptions/wp_exception.dart';
import '../../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../entities/sales_summary_models.dart';
import '../../entities/summary_sales_report_filters.dart';
import '../../services/summary_sales_provider.dart';
import '../view_contracts/summary_sales_view.dart';

class SummarySalesPresenter {
  final SummarySalesView _view;
  final SummarySalesProvider _itemSalesDataProvider;
  final SelectedCompanyProvider _selectedCompanyProvider;

  late SalesSummary salesSummary;

  SummarySalesPresenter(this._view)
      : _itemSalesDataProvider = SummarySalesProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  SummarySalesReportFilters filters = SummarySalesReportFilters();

  SummarySalesPresenter.initWith(
    this._view,
    this._itemSalesDataProvider,
    this._selectedCompanyProvider,
  );

  loadSalesSummaryData() async {
    if (_itemSalesDataProvider.isLoading) return;

    _view.showLoader();
    try {
      salesSummary = await _itemSalesDataProvider.getSummarySales(filters);
      _view.onDidLoadReport();
      if (salesSummary.summary == null) _view.showNoSalesSummaryMessage();
    } on WPException catch (e) {
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
    }
  }

  //MARK: Function to apply Filters

  void onFiltersGotClicked() {
    _view.showSalesSummaryFilter();
  }

  Future applyFilters(SummarySalesReportFilters? newFilters) async {
    if (newFilters == null) return;
    var oldFilter = filters;
    filters = newFilters;
    if (newFilters.selectedDate != oldFilter.selectedDate || newFilters.sortOption != oldFilter.sortOption) {
      await loadSalesSummaryData();
    }
  }

  Future resetFilters() async {
    filters.reset();
    await loadSalesSummaryData();
  }

  String getSelectedCompanyName() => _selectedCompanyProvider.getSelectedCompanyForCurrentUser().name;

  bool get noDataAvailable =>
      salesSummary.data?.categories == null &&
      salesSummary.data?.collections == null &&
      salesSummary.data?.orderTypes == null &&
      salesSummary.summary == null;

  bool get collectionsAvailble => salesSummary.data?.collections != null;
  bool get collectionsAreExpanded => salesSummary.data?.collectionsAreExpanded ?? true;
  getCollection() => salesSummary.data!.collections;

  bool get orderTypesAvailble => salesSummary.data?.orderTypes != null;
  bool get orderTypesAreExpanded => salesSummary.data?.orderTypesAreExpanded ?? true;
  getOrderTypes() => salesSummary.data!.orderTypes;

  bool get categoriesAvailble => salesSummary.data?.categories != null;
  bool get categoriesAreExpanded => salesSummary.data?.categoriesAreExpanded ?? true;
  getCategories() => salesSummary.data!.categories;

  bool get summaryAvailble => salesSummary.summary != null;
  bool get summaryIsExpanded => salesSummary.summary?.summaryIsExpanded ?? true;

  int collectionsAndCategoriesLength(List<CollectionsModel> collectionsAndCategories) =>
      collectionsAndCategories.length;
  String collectionOrCategoryName(int index, List<CollectionsModel> collectionsAndCategories) =>
      collectionsAndCategories[index].item;
  String collectionOrCategoryQuantity(int index, List<CollectionsModel> collectionsAndCategories) =>
      collectionsAndCategories[index].quantity;
  String collectionOrCategoryRevenue(int index, List<CollectionsModel> collectionsAndCategories) =>
      collectionsAndCategories[index].amount;

  String orderTypeNameAt(int index) => salesSummary.data?.orderTypes?[index].item ?? '';
  String orderTypePercentageAt(int index) => salesSummary.data?.orderTypes?[index].percent ?? '';
  String orderTypeRevenueAt(int index) => salesSummary.data?.orderTypes?[index].totalSales ?? '';

  void toggleExpansion(index, isExpanded) {
    switch (index) {
      case 0:
        salesSummary.data?.collectionsAreExpanded = !isExpanded;
        return;

      case 1:
        salesSummary.data?.orderTypesAreExpanded = !isExpanded;

        return;

      case 2:
        salesSummary.data?.categoriesAreExpanded = !isExpanded;

        return;

      case 3:
        salesSummary.summary?.summaryIsExpanded = !isExpanded;

        return;
    }
  }

  String get summaryGrossSales => salesSummary.summary?.grossSales ?? '';
  String get summaryDiscounts => salesSummary.summary?.discounts ?? '';
  String get summaryRefunds => salesSummary.summary?.refund ?? '';
  String get summaryTax => salesSummary.summary?.tax ?? '';
  String get summaryNetSales => salesSummary.summary?.netSales ?? '';
}
