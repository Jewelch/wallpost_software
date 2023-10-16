import 'package:wallpost/_shared/date_range_selector/entities/date_range.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';

import '../../entities/order_details.dart';
import '../../services/order_details_provider.dart';
import '../view_contracts/order_details_view.dart';

class OrderDetailsPresenter {
  final int orderId;
  final OrderDetailsView _view;
  final OrderDetailsProvider _itemSalesDataProvider;
  final SelectedCompanyProvider _selectedCompanyProvider;

  late OrderDetails order;

  OrderDetailsPresenter(this._view, this.orderId, DateRange dateRange)
      : _itemSalesDataProvider = OrderDetailsProvider(dateRange),
        _selectedCompanyProvider = SelectedCompanyProvider();

  OrderDetailsPresenter.initWith(
    this._view,
    this._itemSalesDataProvider,
    this._selectedCompanyProvider,
    this.orderId,
  );

  loadOrderDetails() async {
    if (_itemSalesDataProvider.isLoading) return;

    _view.showLoader();
    try {
      order = await _itemSalesDataProvider.getDetails(orderId);
      _view.onDidLoadDetails();
    } on WPException catch (e) {
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
    }
  }

  // Getters

  String getSelectedCompanyName() => _selectedCompanyProvider.getSelectedCompanyForCurrentUser().name;

  String getCompanyCurrency() {
    return _selectedCompanyProvider.getSelectedCompanyForCurrentUser().currency;
  }
}
