import '../../../../../_shared/exceptions/wp_exception.dart';
import '../../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../entities/hourly_sales_report.dart';
import '../../entities/hourly_sales_report_filters.dart';
import '../../services/hourly_sales_provider.dart';
import '../view_contracts/hourly_sales_view.dart';

class HourlySalesPresenter {
  final HourlySalesView _view;
  final HourlySalesProvider _itemSalesDataProvider;
  final SelectedCompanyProvider _selectedCompanyProvider;

  late HourlySalesReport itemSalesReport;

  HourlySalesPresenter(this._view)
      : _itemSalesDataProvider = HourlySalesProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  HourlySalesReportFilters filters = HourlySalesReportFilters();

  HourlySalesPresenter.initWith(
    this._view,
    this._itemSalesDataProvider,
    this._selectedCompanyProvider,
  );

  loadHourlySalesData() async {
    if (_itemSalesDataProvider.isLoading) return;

    _view.showLoader();
    try {
      itemSalesReport = await _itemSalesDataProvider.getHourlySales(filters);

      _view.onDidLoadReport();
      if (itemSalesReport.hourlySales.isEmpty) _view.showNoHourlySalesMessage();
    } on WPException catch (e) {
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
    }
  }

  //MARK: Function to apply Filters
  void onFiltersGotClicked() {
    _view.showSalesReportFilter();
  }

  Future applyFilters(HourlySalesReportFilters? newFilters) async {
    if (newFilters == null) return;
    var oldFilter = filters;
    filters = newFilters;
    if (newFilters.selectedDate != oldFilter.selectedDate || newFilters.sortOption != oldFilter.sortOption) {
      await loadHourlySalesData();
    }
  }

  Future resetFilters() async {
    filters.reset();
    await loadHourlySalesData();
  }

  // Getters

  String getSelectedCompanyName() => _selectedCompanyProvider.getSelectedCompanyForCurrentUser().name;

  String getHourAtIndex(int index) => itemSalesReport.hourlySales[index].hour;

  String getTicketsNumberAtIndex(int index) => 'Tickets(${itemSalesReport.hourlySales[index].ticketsCount})';

  String getTotalRevenueAtIndex(int index) => itemSalesReport.hourlySales[index].ticketsRevenue;

  int getDataListLength() => itemSalesReport.hourlySales.length;
}
