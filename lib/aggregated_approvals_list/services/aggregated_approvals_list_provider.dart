import 'dart:async';

import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/aggregated_approvals_list/constants/aggregated_approval_urls.dart';

import '../entities/aggregated_approval.dart';

class AggregatedApprovalsListProvider {
  final NetworkAdapter _networkAdapter;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;

  AggregatedApprovalsListProvider.initWith(this._networkAdapter);

  AggregatedApprovalsListProvider() : _networkAdapter = WPAPI();

  Future<List<AggregatedApproval>> getAllApprovals({String? companyId}) async {
    var url = AggregatedApprovalUrls.getAggregatedApprovalsListUrl(companyId);
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

  Future<List<AggregatedApproval>> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<AggregatedApproval>>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! List<Map<String, dynamic>>) throw WrongResponseFormatException();

    var responseMapList = apiResponse.data as List<Map<String, dynamic>>;

    return _readItemsFromResponse(responseMapList);
  }

  List<AggregatedApproval> _readItemsFromResponse(List<Map<String, dynamic>> responseMapList) {
    try {
      var approvalsList = <AggregatedApproval>[];
      for (var responseMap in responseMapList) {
        AggregatedApproval? approvalAggregated = AggregatedApproval.fromJson(responseMap);
        approvalsList.add(approvalAggregated);
      }
      return approvalsList;
    } catch (e) {
      throw InvalidResponseException();
    }
  }
}
