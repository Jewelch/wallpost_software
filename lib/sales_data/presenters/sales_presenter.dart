import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/sales_data/services/sales_data_provider.dart';
import 'package:wallpost/sales_data/ui/contracts/SalesDataView.dart';

class SalesPresenter {
  SalesDataProvider _salesDataProvider;
  SalesDataView _view;

  SalesPresenter(this._view) : _salesDataProvider = SalesDataProvider();

  SalesPresenter.initWith(this._view, this._salesDataProvider);

  Future loadSalesData() async {
    if (_salesDataProvider.isLoading) return;
    _view.showLoader();
    try {
      var salesData = await _salesDataProvider.getSalesAmounts();
      _view.hideLoader();
      _view.showSalesData(salesData);
    } on WPException catch (e) {
      _view.hideLoader();
      _view.showErrorMessage(e.userReadableMessage + "\n\nTap here to reload.");
    }
  }
}
