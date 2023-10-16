import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/orders_summary/list/entities/orders_summary.dart';

import '../../../../../../_shared/exceptions/wp_exception.dart';
import '../../../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../services/orders_summary_provider.dart';
import '../view_contracts/orders_summary_view.dart';

class OrdersSummaryPresenter {
  final OrdersSummaryView _view;
  final OrdersSummaryProvider _provider;
  final SelectedCompanyProvider _selectedCompanyProvider;

  OrdersSummary? ordersSummary;

  OrdersSummaryPresenter(this._view)
      : _provider = OrdersSummaryProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  DateRange filters = DateRange();

  OrdersSummaryPresenter.initWith(
    this._view,
    this._provider,
    this._selectedCompanyProvider,
  );

  loadNextOrdersSummary() async {
    if (_provider.isLoading ) return;
    (ordersSummary?.orders.isEmpty ?? true) ? _view.showLoader() : _view.showPaginationLoader();
    try {
      var summary = await _provider.getNext(filters);
      if (ordersSummary == null) {
        ordersSummary = summary;
      } else {
        ordersSummary!.orders.addAll(summary.orders);
      }
      _view.onDidLoadReport();
      if (ordersSummary?.orders.isEmpty ?? true) _view.showNoSummaryMessage();
    } on WPException catch (e) {
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
    }
  }

  //MARK: Function to apply Filters

  void onFiltersGotClicked() {
    _view.showFilter();
  }

  Future applyFilters(DateRange? newFilters) async {
    if (newFilters == null) return;
    filters = newFilters;
    ordersSummary = null;
    await loadNextOrdersSummary();
  }

  Future resetFilters() async {
    ordersSummary = null;
    filters.applyToday();
    await loadNextOrdersSummary();
  }

  // Getters

  String getSelectedCompanyName() => _selectedCompanyProvider.getSelectedCompanyForCurrentUser().name;

  String getCompanyCurrency() {
    return _selectedCompanyProvider.getSelectedCompanyForCurrentUser().currency;
  }
}
