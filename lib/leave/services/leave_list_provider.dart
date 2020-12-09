import 'dart:async';

import 'package:wallpost/_wp_core/company_management/services/selected_employee_provider.dart';
import 'package:wallpost/_wp_core/wpapi/wp_api.dart';
import 'package:wallpost/leave/constants/leave_urls.dart';
import 'package:wallpost/leave/entities/leave_list_item.dart';

class LeaveListProvider {
  final SelectedEmployeeProvider _selectedEmployeeProvider;
  final NetworkAdapter _networkAdapter;
  final int _perPage = 15;
  int _pageNumber = 0;
  bool _didReachListEnd = false; // ignore: unused_field
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;

  LeaveListProvider.initWith(this._selectedEmployeeProvider, this._networkAdapter);

  LeaveListProvider()
      : _selectedEmployeeProvider = SelectedEmployeeProvider(),
        _networkAdapter = WPAPI();

  void reset() {
    _pageNumber = 0;
    _didReachListEnd = false;
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    isLoading = false;
  }

  Future<List<LeaveListItem>> getNext() async {
    var employee = _selectedEmployeeProvider.getSelectedEmployeeForCurrentUser();
    var url = LeaveUrls.leaveListUrl(employee.companyId, employee.v1Id, '$_pageNumber', '$_perPage');
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

  Future<List<LeaveListItem>> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<LeaveListItem>>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! List<Map<String, dynamic>>) throw WrongResponseFormatException();

    var responseMapList = apiResponse.data as List<Map<String, dynamic>>;
    return _readItemsFromResponse(responseMapList);
  }

  List<LeaveListItem> _readItemsFromResponse(List<Map<String, dynamic>> responseMapList) {
    try {
      var leaveListItemList = <LeaveListItem>[];
      for (var responseMap in responseMapList) {
        var leaveListItem = LeaveListItem.fromJson(responseMap);
        leaveListItemList.add(leaveListItem);
      }
      _updatePaginationRelatedData(leaveListItemList.length);
      return leaveListItemList;
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
