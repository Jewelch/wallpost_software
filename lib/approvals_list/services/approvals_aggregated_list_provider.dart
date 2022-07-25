import 'dart:async';

import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/approvals_list/entities/approval_aggregated.dart';
import 'package:wallpost/dashboard_core/constants/dashboard_management_urls.dart';


class ApprovalsAggregatedListProvider {
  final NetworkAdapter _networkAdapter;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;

  ApprovalsAggregatedListProvider.initWith(this._networkAdapter);

  ApprovalsAggregatedListProvider()
      : _networkAdapter = WPAPI();

  void reset() {
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    isLoading = false;
  }

  Future<List<ApprovalAggregated>> get() async {
    var url = DashboardManagementUrls.getApprovalAggregatedListUrl();
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

  Future<List<ApprovalAggregated>> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<ApprovalAggregated>>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! List<Map<String, dynamic>>) throw WrongResponseFormatException();

    var responseMapList = apiResponse.data as List<Map<String, dynamic>>;

    return _readItemsFromResponse(responseMapList);
  }

  List<ApprovalAggregated> _readItemsFromResponse(List<Map<String, dynamic>> responseMapList) {
    try {
      var approvalsList = <ApprovalAggregated>[];
      for (var responseMap in responseMapList) {
        ApprovalAggregated? approvalAggregated = ApprovalAggregated.fromJson(responseMap);
          approvalsList.add(approvalAggregated);
      }
      return approvalsList;
    } catch (e) {
      throw InvalidResponseException();
    }
  }


}
