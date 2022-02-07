import 'dart:async';

import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/attendance_adjustment/constants/attendance_adjustment_urls.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';
import 'package:wallpost/company_list/services/selected_employee_provider.dart';

class AttendanceListProvider {
  final SelectedEmployeeProvider _selectedEmployeeProvider;
  final NetworkAdapter _networkAdapter;
  late String _sessionId;
  bool isLoading = false;

  AttendanceListProvider.initWith(
      this._selectedEmployeeProvider, this._networkAdapter);

  AttendanceListProvider()
      : _selectedEmployeeProvider = SelectedEmployeeProvider(),
        _networkAdapter = WPAPI();

  void reset() {
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    isLoading = false;
  }

  Future<List<AttendanceListItem>> get(int month, int year) async {
    var employee =
        _selectedEmployeeProvider.getSelectedEmployeeForCurrentUser();

    var url = AttendanceAdjustmentUrls.getAttendanceListsUrl(
        employee.companyId, employee.v1Id, month, year);
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

  Future<List<AttendanceListItem>> _processResponse(
      APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId)
      return Completer<List<AttendanceListItem>>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>)
      throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    try {
      return _readItemsFromResponse(responseMap);
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  List<AttendanceListItem> _readItemsFromResponse(
      Map<String, dynamic> responseMap) {
    List<AttendanceListItem> attendanceListItems = [];
    var sift = Sift();
    var dataMap = sift.readMapListFromMap(responseMap, "data");
    for (var attendanceJson in dataMap) {
      var listItem = AttendanceListItem.fromJSon(attendanceJson);
      attendanceListItems.add(listItem);
    }
    _removeTodaysAttendanceIfUserHasNotPunchedOutYet(attendanceListItems);
    return attendanceListItems;
  }

  void _removeTodaysAttendanceIfUserHasNotPunchedOutYet(
      List<AttendanceListItem> attendanceListItems) {
    attendanceListItems.removeWhere((attendanceItem) {
      var today = DateTime.now();
      var attendanceDate = attendanceItem.date;
      return attendanceDate.year == today.year &&
          attendanceDate.month == today.month &&
          attendanceDate.day == today.day &&
          attendanceItem.punchOutTime == null;
    });
  }
}
