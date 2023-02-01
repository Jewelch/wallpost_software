import '../../../../../_shared/exceptions/wp_exception.dart';
import '../../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../entities/houlry_sales_model.dart';
import '../../entities/hourly_sales_report_filters.dart';
import '../../services/hourly_sales_provider.dart';
import '../view_contracts/item_sales_view.dart';

class HourlySalesPresenter {
  final HoulySalesView _view;
  final HourlySalesProvider _itemSalesDataProvider;
  final SelectedCompanyProvider _selectedCompanyProvider;

  late HourlySalesReport itemSalesReport;

  List<HourlySalesItem> _itemsList = [];
  var index = 0;

  HourlySalesPresenter(this._view)
      : _itemSalesDataProvider = HourlySalesProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  HourlySalesReportFilters filters = HourlySalesReportFilters();

  HourlySalesPresenter.initWith(
    this._view,
    this._itemSalesDataProvider,
    this._selectedCompanyProvider,
  );

  loadItemSalesData() async {
    if (_itemSalesDataProvider.isLoading) return;

    _view.showLoader();
    try {
      var dateFilters = filters.dateRangeFilters;
      itemSalesReport = await _itemSalesDataProvider.getHourlySales(dateFilters);

      _view.onDidLoadReport();
      if (itemSalesReport.hourlySales.isEmpty) _view.showNoItemSalesBreakdownMessage();

      //create a list of all items in all categories
      _itemsList.clear();
      // itemSalesReport.hourlySales.forEach((element) => element.items.forEach((item) => _itemsList.add(item)));
    } on WPException catch (e) {
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
    }
  }

  //MARK: Function to apply Filters

  Future applyFilters(HourlySalesReportFilters? newFilters) async {
    if (newFilters == null) return;
    var oldFilter = filters;
    filters = newFilters;
    if (newFilters.dateRangeFilters != oldFilter.dateRangeFilters) {
      await loadItemSalesData();
    }
    if (newFilters.sortOptions != oldFilter.sortOptions) {
      //TODO: check this
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

  // Top card getters

  // Category wise

  String getHourAtIndex(int index) => itemSalesReport.hourlySales[index].hour;
  String getTicketsNumberAtIndex(int index) => 'Tickets(${itemSalesReport.hourlySales[index].ticketsCount})';

  String getCategoryTotalToDisplayRevenueAtIndex(int index) => itemSalesReport.hourlySales[index].ticketsRevenue;

  int getDataListLength() => itemSalesReport.hourlySales.length;

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
