import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/entities/sales_item_view_options.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/services/item_sales_provider.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/ui/view_contracts/item_sales_view.dart';

class ItemSalesPresenter {
  ItemSalesView _view;
  SelectedCompanyProvider _selectedCompanyProvider;
  ItemSalesProvider _itemSalesDataProvider;
  ItemSalesPresenter(this._view)
      : _selectedCompanyProvider = SelectedCompanyProvider(),
        _itemSalesDataProvider = ItemSalesProvider();

  dynamic salesItemData;

  SalesItemWiseOptions _salesItemWiseOption = SalesItemWiseOptions.viewAsCategory;
  DateRangeFilters _dateRangeFilters = DateRangeFilters();

  ItemSalesPresenter.initWith(
    this._view,
    this._selectedCompanyProvider,
    this._itemSalesDataProvider,
  );

  List<String> filterTypeList = [
    "Sort by:",
    "Date:",
    "View:",
  ];

  loadItemSalesData() async {
    if (_itemSalesDataProvider.isLoading) return;

    _view.showLoader();
    try {
      salesItemData = await _itemSalesDataProvider.getItemSales(_dateRangeFilters, _salesItemWiseOption);

      _view.updateSalesItemData();
      salesItemData.isNotEmpty ? _view.showSalesBreakDowns() : _view.showNoSalesBreakdownMessage();
    } on WPException catch (e) {
      _view.showErrorMessage("${e.userReadableMessage}" + "\n\nTap here to reload.");
    }
  }

  //MARK: Function to initiate filter selection

  void onFiltersGotClicked() {
    _view.showSalesReportFilter();
  }

  //MARK: Functions to apply sales breakdown type filter

  void selectSalesBreakDownWiseAtIndex(int index) {
    _salesItemWiseOption = SalesItemWiseOptions.values[index];
    _view.onDidChangeSalesItemWise();
  }

  // Getters

  String getSelectedCompanyName() => _selectedCompanyProvider.getSelectedCompanyForCurrentUser().name;
  String getFilterType(int index) => filterTypeList[index];
  // String getCategoryNameAtIndex(int index) => _salesData?.categories?[index].categoryName ?? 'No data';
  // num getCategoryRevenueAtIndex(int index) => _salesData?.categories?[index].totalRevenue ?? 0;
  // num getCategoryQtyAtIndex(int index) => _salesData?.categories?[index].totalQuantity ?? 0;
  // String getTotalRevenue() => _salesData?.categories?[0].totalQuantity.toString() ?? 'No data';
  String getTotalQuantity() => '52';
  String getQuantity() => '18';
  String getRevenue() => '23';
  String getSumRevenue() => '5000';
  // int getCategoryWiseListLength() => _salesData?.categories?.length ?? 0;
  // String getCategoryName(int index) => _salesData?.categories?[index].categoryName ?? '';
}
