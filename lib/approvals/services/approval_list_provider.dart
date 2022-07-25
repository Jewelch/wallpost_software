import 'dart:async';

import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/company_core/services/selected_company_provider.dart';
import 'package:wallpost/dashboard_core/constants/dashboard_management_urls.dart';

import '../../_shared/exceptions/mapping_exception.dart';
import '../entities/approval.dart';
import '../entities/attendance_adjustment_approval.dart';
import '../entities/expense_request_approval.dart';
import '../entities/leave_approval.dart';

class ApprovalListProvider {
  final NetworkAdapter _networkAdapter;
  final SelectedCompanyProvider _selectedCompanyProvider;
  final int _perPage = 15;
  int _pageNumber = 1;
  bool _didReachListEnd = false;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;
  late num actionsCount;

  ApprovalListProvider.initWith(this._networkAdapter, this._selectedCompanyProvider);

  ApprovalListProvider()
      : _networkAdapter = WPAPI(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  void reset() {
    _pageNumber = 1;
    _didReachListEnd = false;
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    isLoading = false;
  }

  Future<List<Approval>> getNext() async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url = DashboardManagementUrls.getApprovalsUrl(companyId, _pageNumber, _perPage);
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

  Future<List<Approval>> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<Approval>>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! List<Map<String, dynamic>>) throw WrongResponseFormatException();

    var responseMapList = apiResponse.data as List<Map<String, dynamic>>;
    var metaDataMap = apiResponse.metaData;
    _processMetadata(metaDataMap);

    return _readItemsFromResponse(responseMapList);
  }

  void _processMetadata(Map<String, dynamic>? metaDataMap) {
    var sift = Sift();
    try {
      actionsCount = sift.readNumberFromMap(metaDataMap, "total");
    } on SiftException catch (e) {
      throw MappingException('Failed to cast Action data metadata response. Error message - ${e.errorMessage}');
    }
  }

  List<Approval> _readItemsFromResponse(List<Map<String, dynamic>> responseMapList) {
    try {
      var approvalsList = <Approval>[];
      for (var responseMap in responseMapList) {
        Approval? approval = convertMapToApproval(responseMap);
        if (approval != null) approvalsList.add(approval);
      }
      _updatePaginationRelatedData(approvalsList.length);
      return approvalsList;
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  Approval? convertMapToApproval(Map<String, dynamic> responseMap) {
    var sift = Sift();
    var approvalType = sift.readStringFromMap(responseMap, 'approvalType');
    switch (approvalType) {
      case "leaveApproval":
        return LeaveApproval.fromJson(responseMap);
      case "expenseRequestApproval":
        return ExpenseRequestApproval.fromJson(responseMap);
      case "attendanceAdjustment":
        return AttendanceAdjustmentApproval.fromJson(responseMap);
    }

    return null;
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
