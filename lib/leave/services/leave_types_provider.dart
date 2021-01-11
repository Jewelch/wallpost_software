import 'dart:async';

import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_employee_provider.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/leave/constants/leave_urls.dart';
import 'package:wallpost/leave/entities/leave_type.dart';

class LeaveTypesProvider {
  final SelectedEmployeeProvider _selectedEmployeeProvider;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  String _sessionId;

  LeaveTypesProvider.initWith(
      this._selectedEmployeeProvider, this._networkAdapter);

  LeaveTypesProvider()
      : _selectedEmployeeProvider = SelectedEmployeeProvider(),
        _networkAdapter = WPAPI();

  void reset() {
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    isLoading = false;
  }

  Future<List<LeaveType>> getLeaveTypes() async {
    var employee =
        _selectedEmployeeProvider.getSelectedEmployeeForCurrentUser();
    var url = LeaveUrls.leaveTypesUrl(employee.companyId, employee.v1Id);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
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

  Future<List<LeaveType>> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId)
      return Completer<List<LeaveType>>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>)
      throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    return _readLeaveTypesFromResponse(responseMap);
  }

  List<LeaveType> _readLeaveTypesFromResponse(
      Map<String, dynamic> responseMap) {
    var sift = Sift();

    try {
      var leaveTypesMapList =
          sift.readMapListFromMap(responseMap, 'leaveTypes');
      return _readLeaveTypesFromMapList(leaveTypesMapList);
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  List<LeaveType> _readLeaveTypesFromMapList(
      List<Map<String, dynamic>> jsonMapList) {
    var items = <LeaveType>[];
    for (var jsonMap in jsonMapList) {
      var item = LeaveType.fromJson(jsonMap);
      items.add(item);
    }
    return items;
  }
}
