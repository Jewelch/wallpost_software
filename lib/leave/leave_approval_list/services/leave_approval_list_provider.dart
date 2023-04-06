import 'dart:async';

import 'package:sift/sift.dart';

import '../../../_shared/exceptions/wrong_response_format_exception.dart';
import '../../../_wp_core/wpapi/services/wp_api.dart';
import '../constants/leave_approval_list_urls.dart';
import '../entities/leave_approval_list_item.dart';

class LeaveApprovalListProvider {
  final String _companyId;
  final NetworkAdapter _networkAdapter;
  final int _perPage = 15;
  int _pageNumber = 1;
  bool _didReachListEnd = false;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;

  LeaveApprovalListProvider.initWith(this._companyId, this._networkAdapter);

  LeaveApprovalListProvider(this._companyId) : _networkAdapter = WPAPI();

  void reset() {
    _pageNumber = 1;
    _didReachListEnd = false;
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    isLoading = false;
  }

  Future<List<LeaveApprovalListItem>> getNext() async {
    var url = LeaveApprovalListUrls.pendingApprovalListUrl(_companyId, _pageNumber, _perPage);
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

  Future<List<LeaveApprovalListItem>> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<LeaveApprovalListItem>>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMapList = readApprovalMapList(apiResponse.data);
    return _readItemsFromResponse(responseMapList);
  }

  List<Map<String, dynamic>> readApprovalMapList(Map<String, dynamic> response) {
    try {
      return Sift().readMapListFromMap(response, "detail");
    } on SiftException {
      throw InvalidResponseException();
    }
  }

  List<LeaveApprovalListItem> _readItemsFromResponse(List<Map<String, dynamic>> responseMapList) {
    try {
      var approvalList = <LeaveApprovalListItem>[];
      for (var responseMap in responseMapList) {
        var approval = LeaveApprovalListItem.fromJson(responseMap);
        approvalList.add(approval);
      }
      _updatePaginationRelatedData(approvalList.length);
      return approvalList;
    } catch (_) {
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
