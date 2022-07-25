import 'dart:async';

import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/leave_approvals/constants/leave_approval_urls.dart';
import 'package:wallpost/leave_approvals/entities/leave_approval.dart';
import 'package:wallpost/leave_approvals/entities/leave_approval_status.dart';

import '../../company_core/services/selected_employee_provider.dart';

class LeaveApprovalListProvider {
  final SelectedEmployeeProvider _selectedEmployeeProvider;
  final NetworkAdapter _networkAdapter;
  final int _perPage = 15;
  int _pageNumber = 1;
  bool _didReachListEnd = false;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;

  LeaveApprovalListProvider.initWith(this._selectedEmployeeProvider, this._networkAdapter);

  LeaveApprovalListProvider()
      : _selectedEmployeeProvider = SelectedEmployeeProvider(),
        _networkAdapter = WPAPI();

  void reset() {
    _pageNumber = 1;
    _didReachListEnd = false;
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    isLoading = false;
  }

  Future<List<LeaveApproval>> getNext(LeaveApprovalStatus approvalStatus) async {
    var employee = _selectedEmployeeProvider.getSelectedEmployeeForCurrentUser();
    var url = LeaveApprovalUrls.leaveApprovalListUrl(employee.companyId, approvalStatus, _pageNumber, _perPage);
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

  Future<List<LeaveApproval>> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<LeaveApproval>>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMapList = getLeaveApprovalMapList(apiResponse.data);
    return _readItemsFromResponse(responseMapList);
  }

  List<Map<String, dynamic>> getLeaveApprovalMapList(Map<String, dynamic> response) {
    try {
      return Sift().readMapListFromMap(response, "detail");
    } on SiftException {
      throw InvalidResponseException();
    }
  }

  List<LeaveApproval> _readItemsFromResponse(List<Map<String, dynamic>> responseMapList) {
    try {
      var leaveApprovalList = <LeaveApproval>[];
      for (var responseMap in responseMapList) {
        var leaveApproval = LeaveApproval.fromJson(responseMap);
        leaveApprovalList.add(leaveApproval);
      }
      _updatePaginationRelatedData(leaveApprovalList.length);
      return leaveApprovalList;
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

  bool get didReachListEnd => _didReachListEnd;
}
