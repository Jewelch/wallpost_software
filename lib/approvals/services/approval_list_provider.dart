import 'dart:async';

import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/company_core/entities/company.dart';
import 'package:wallpost/dashboard_core/constants/dashboard_management_urls.dart';

import '../entities/approval.dart';

class ApprovalListProvider {
  final NetworkAdapter _networkAdapter;
  final int _perPage = 15;
  int _pageNumber = 1;
  bool _didReachListEnd = false;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;

  ApprovalListProvider.initWith(this._networkAdapter);

  ApprovalListProvider() : _networkAdapter = WPAPI();

  void reset() {
    _pageNumber = 1;
    _didReachListEnd = false;
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    isLoading = false;
  }

  Future<List<Approval>> getNext({Company? company}) async {
    var url = DashboardManagementUrls.getApprovalsUrl(company?.id, _pageNumber, _perPage);
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
    return _readItemsFromResponse(responseMapList);
  }

  List<Approval> _readItemsFromResponse(List<Map<String, dynamic>> responseMapList) {
    try {
      var approvalsList = <Approval>[];
      for (var responseMap in responseMapList) {
        var approval = Approval.fromJson(responseMap);
        approvalsList.add(approval);
      }
      _updatePaginationRelatedData(approvalsList.length);
      return approvalsList;
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
