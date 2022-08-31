import 'dart:async';

import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';

import '../constants/leave_detail_urls.dart';
import '../entities/leave_detail.dart';

class LeaveDetailProvider {
  final String _companyId;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  late String _sessionId;

  LeaveDetailProvider.initWith(this._companyId, this._networkAdapter);

  LeaveDetailProvider(this._companyId) : _networkAdapter = WPAPI();

  Future<LeaveDetail> get(String leaveId) async {
    var url = LeaveDetailUrls.leaveDetailUrl(_companyId, leaveId);
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

  Future<LeaveDetail> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<LeaveDetail>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    try {
      return LeaveDetail.fromJson(responseMap);
    } catch (e) {
      throw InvalidResponseException();
    }
  }
}
