import '../../../../../_shared/exceptions/wp_exception.dart';
import '../../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../entities/item_sales_model.dart';
import '../../entities/item_sales_report_filters.dart';
import '../../services/item_sales_provider.dart';
import '../../utils/item_sales_sorter.dart';
import '../view_contracts/item_sales_view.dart';

class ItemSalesPresenter {
  final ItemSalesView _view;
  final ItemSalesProvider _itemSalesDataProvider;
  final ItemSalesSorter _itemSalesSorter;
  final SelectedCompanyProvider _selectedCompanyProvider;

  late ItemSalesReport itemSalesReport;

  List<ItemSales> _itemsList = [];
  var index = 0;

  ItemSalesPresenter(this._view)
      : _itemSalesDataProvider = ItemSalesProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider(),
        _itemSalesSorter = ItemSalesSorter();

  ItemSalesReportFilters filters = ItemSalesReportFilters();

  ItemSalesPresenter.initWith(
    this._view,
    this._itemSalesDataProvider,
    this._itemSalesSorter,
    this._selectedCompanyProvider,
  );

  loadItemSalesData() async {
    if (_itemSalesDataProvider.isLoading) return;

    _view.showLoader();
    try {
      var dateFilters = filters.dateFilters;
      itemSalesReport = await _itemSalesDataProvider.getItemSales(dateFilters);

      _view.onDidLoadReport();
      if (itemSalesReport.categoriesSales.isEmpty) _view.showNoItemSalesBreakdownMessage();

      //create a list of all items in all categories
      _itemsList.clear();
      itemSalesReport.categoriesSales.forEach((element) => element.items.forEach((item) => _itemsList.add(item)));
    } on WPException catch (e) {
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
    }
  }

  //MARK: Function to apply Filters

  Future applyFilters(ItemSalesReportFilters? newFilters) async {
    if (newFilters == null) return;
    var oldFilter = filters;
    filters = newFilters;
    if (newFilters.dateFilters != oldFilter.dateFilters) {
      await loadItemSalesData();
    }
    if (newFilters.sortOption != oldFilter.sortOption) {
      itemSalesReport = _itemSalesSorter.sortBreakDowns(itemSalesReport, filters.sortOption);
      _itemsList = _itemSalesSorter.sortAllBreakDownItems(itemSalesReport, filters.sortOption);
      _view.onDidChangeFilters();
    }
    if (newFilters.salesItemWiseOptions != oldFilter.salesItemWiseOptions) {
      _view.onDidChangeFilters();
    }
  }

  void onFiltersGotClicked() {
    _view.showSalesReportFilter();
  }

  Future resetFilters() async {
    filters.reset();
    await loadItemSalesData();
  }

  // Getters

  String getSelectedCompanyName() => _selectedCompanyProvider.getSelectedCompanyForCurrentUser().name;

  String getCompanyCurrency() {
    return _selectedCompanyProvider.getSelectedCompanyForCurrentUser().currency;
  }

  // Top card getters

  String getTotalRevenue() => itemSalesReport.totalRevenue;

  String getTotalOfAllItemsQuantity() => itemSalesReport.totalOfAllItemsQuantities;

  // Category wise

  String getTotalCategories() => itemSalesReport.totalCategories.toString();

  String getCategoryCardHeader() => "Categories(${itemSalesReport.totalCategories.toString()})";

  String getCategoryNameAtIndex(int index) => itemSalesReport.categoriesSales[index].categoryName;

  String getCategoryTotalToDisplayRevenueAtIndex(int index) =>
      itemSalesReport.categoriesSales[index].totalRevenueToDisplay;

  String getCategoryTotalQtyAtIndex(int index) => itemSalesReport.categoriesSales[index].totalQuantity;

  // Item wise

  int getItemsListLength() => _itemsList.length;

  String getItemCardHeader() => "Items(${getItemsListLength().toString()})";

  String getItemNameAtIndex(int index) => _itemsList[index].itemName;

  String getItemQtyAtIndex(int index) => _itemsList[index].qty;

  String getItemRevenueToDisplayAtIndex(int index) => _itemsList[index].revenueToDisplay.toString();

  // Item and Category wise

  String getNameOfSpecificItem(ItemSales item) => item.itemName;

  String getQtyOfSpecificItem(ItemSales item) => item.qty;

  String getRevenueToDisplayOfSpecificItem(ItemSales item) => item.revenueToDisplay.toString();

  String getCategoryNameCardHeader(CategoriesSales breakDown) => breakDown.categoryName;

  String getBreakDownRevenueForCategory(CategoriesSales breakDown) => breakDown.totalRevenueToDisplay;

  void toggleCategoryExpansionStatusAtIndex(int index) =>
      itemSalesReport.categoriesSales[index].isExpanded = !(itemSalesReport.categoriesSales[index].isExpanded);

  List<CategoriesSales> getItemSalesBreakDownList() => itemSalesReport.categoriesSales;

  int getDataListLength() => itemSalesReport.categoriesSales.length;

/*
  TODO: Add feature to share reports
  void shareReports() {
    Share.shareXFiles(
      [XFile('dsdsd')],
      text: 'Share reports text',
      subject: 'Share reports subject',
    );
  }
  */
}
