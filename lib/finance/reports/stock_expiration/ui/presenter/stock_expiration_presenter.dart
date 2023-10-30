import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';

import '../../entities/stock_expiration.dart';
import '../../services/stock_expiration_provider.dart';
import '../view_contracts/stock_expiration_view.dart';

class StocksExpirationPresenter {
  final StocksExpirationView _view;
  final StocksExpirationProvider _provider;
  final SelectedCompanyProvider _selectedCompanyProvider;

  List<StockExpiration> _stocksExpiration = [];
  String searchText = '';
  bool isExpired = true;
  int days = 0;

  StocksExpirationPresenter(this._view)
      : _provider = StocksExpirationProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  StocksExpirationPresenter.initWith(
    this._view,
    this._provider,
    this._selectedCompanyProvider,
  );

  loadNext() async {
    if (_provider.isLoading) return;
    (_stocksExpiration.isEmpty) ? _view.showLoader() : _view.showPaginationLoader();
    try {
      var stocks = await _provider.getNext(isExpired, days);
      _stocksExpiration.addAll(stocks);
      _view.onDidLoadReport();
      if (stocks.isEmpty) _view.showNoStocksMessage();
    } on WPException catch (e) {
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
    }
  }

  void onSearch(String search) {
    searchText = search;
    _view.onDidLoadReport();
  }

  void onSelectOnlyExpired() async {
    isExpired = true;
    _provider.reset();
    _stocksExpiration.clear();
    await loadNext();
  }

  void onSelectExpiredInDays(int days) async {
    isExpired = false;
    this.days = days;
    _provider.reset();
    _stocksExpiration.clear();
    await loadNext();
  }

  // Getters

  List<StockExpiration> get stocksExpiration =>
      _stocksExpiration.where((element) => element.name.toLowerCase().contains(searchText.toLowerCase())).toList();

  String getCompanyName() => _selectedCompanyProvider.getSelectedCompanyForCurrentUser().name;

  String getCompanyCurrency() {
    return _selectedCompanyProvider.getSelectedCompanyForCurrentUser().currency;
  }

  bool isDatePositive(String dateString) {
    var date = DateTime.parse(dateString) ;
    return date.isAfter(DateTime.now());
  }

  void onSelectFilter(bool onlyExpired, int days) {
    if (onlyExpired) {
      onSelectOnlyExpired();
    } else {
      onSelectExpiredInDays(days);
    }
  }
}
