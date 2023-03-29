import 'dart:async';

import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';

import '../../../_shared/date_range_selector/entities/date_range.dart';
import '../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../constants/dashboard_urls.dart';
import '../entities/aggregated_sales_data.dart';
import '../ui/views/screens/dashboard_screen.dart';

class AggregatedSalesDataProvider {
  final NetworkAdapter _networkAdapter;
  final SelectedCompanyProvider _selectedCompanyProvider;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;
  final DashboardContext dashboardContext;

  AggregatedSalesDataProvider({required this.dashboardContext})
      : _networkAdapter = WPAPI(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  AggregatedSalesDataProvider.initWith(
    this._networkAdapter,
    this._selectedCompanyProvider,
    this.dashboardContext,
  );

  Future<AggregatedSalesData> getSalesAmounts(DateRange dateRange) async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url = DashboardUrls.getSalesAmountsUrl(companyId, dateRange,dashboardContext);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);

    _isLoading = true;
    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      _isLoading = false;
      return _processResponse(apiResponse);
    } on APIException catch (exception) {
      _isLoading = false;
      throw exception;
    }
  }

  Future<AggregatedSalesData> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<AggregatedSalesData>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    try {
      return AggregatedSalesData.fromJson(responseMap);
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  bool get isLoading => _isLoading;
}
