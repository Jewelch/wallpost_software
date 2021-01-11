import 'dart:async';

import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_employee_provider.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/leave/constants/leave_urls.dart';
import 'package:wallpost/leave/entities/leave_airport.dart';

class LeaveAirportListProvider {
  final SelectedEmployeeProvider _selectedEmployeeProvider;
  final NetworkAdapter _networkAdapter;
  final int _perPage = 15;
  int _pageNumber = 0;
  bool _didReachListEnd = false;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;

  LeaveAirportListProvider.initWith(
      this._selectedEmployeeProvider, this._networkAdapter);

  LeaveAirportListProvider()
      : _selectedEmployeeProvider = SelectedEmployeeProvider(),
        _networkAdapter = WPAPI();

  void reset() {
    _pageNumber = 0;
    _didReachListEnd = false;
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    isLoading = false;
  }

  Future<List<LeaveAirport>> getNext({String searchText}) async {
    var companyId =
        _selectedEmployeeProvider.getSelectedEmployeeForCurrentUser().companyId;
    var employeeId =
        _selectedEmployeeProvider.getSelectedEmployeeForCurrentUser().v1Id;
    var url = LeaveUrls.airportsListUrl(
        companyId, employeeId, searchText, _pageNumber, _perPage);
    var apiRequest = APIRequest.withId(url, _sessionId);
    isLoading = true;

    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      isLoading = false;
      return _processResponse(apiResponse);
    } on APIException catch (exception) {
      isLoading = false;
      throw exception;
    }
  }

  Future<List<LeaveAirport>> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId)
      return Completer<List<LeaveAirport>>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! List<Map<String, dynamic>>)
      throw WrongResponseFormatException();

    var responseMapList = apiResponse.data as List<Map<String, dynamic>>;
    return _readItemsFromResponse(responseMapList);
  }

  List<LeaveAirport> _readItemsFromResponse(
      List<Map<String, dynamic>> responseMapList) {
    try {
      var leaveAirportList = <LeaveAirport>[];
      for (var responseMap in responseMapList) {
        var leaveAirport = LeaveAirport.fromJson(responseMap);
        leaveAirportList.add(leaveAirport);
      }
      _updatePaginationRelatedData(leaveAirportList.length);
      return leaveAirportList;
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  void _updatePaginationRelatedData(int noOfItemsReceived) {
    if (noOfItemsReceived > 0) {
      _pageNumber += 1;
    }
    if (noOfItemsReceived < _perPage) {
      _didReachListEnd = true;
    }
  }

  int getCurrentPageNumber() {
    return _pageNumber;
  }
}
