import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/services/sales_data_provider.dart';

import '../view_contracts/sales_data_view.dart';

class SalesPresenter {
  SalesDataProvider _salesDataProvider;
  RestaurantDashboardView _view;

  SalesPresenter(this._view) : _salesDataProvider = SalesDataProvider();

  SalesPresenter.initWith(this._view, this._salesDataProvider);

  Future loadSalesData() async {
    if (_salesDataProvider.isLoading) return;

    _view.showLoader();
    try {
      var salesData = await _salesDataProvider.getSalesAmounts();
      _view.showSalesData(salesData);
    } on WPException catch (e) {
      _view.showErrorMessage(e.userReadableMessage + "\n\nTap here to reload.");
    }
  }
}
