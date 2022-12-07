import 'dart:async';

import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/network_adapter.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';

import '../constants/finance_dashboard_urls.dart';
import '../entities/finance_dashboard_data.dart';

class FinancialDashBoardProvider{
  final NetworkAdapter _networkAdapter;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;

  FinancialDashBoardProvider.initWith(this._networkAdapter);

  FinancialDashBoardProvider() : _networkAdapter = WPAPI();

  Future<FinanceDashBoardData> get() async {

    print("1111111111111");
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var url = FinanceDashBoardUrls.getAttendanceDetailsUrl();

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

  Future<FinanceDashBoardData> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<FinanceDashBoardData>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    try {
      return FinanceDashBoardData.fromJson(responseMap);
    } on MappingException catch (_) {
      throw InvalidResponseException();
    }
  }

  bool get isLoading => _isLoading;

}
