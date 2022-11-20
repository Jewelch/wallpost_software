import 'dart:async';

import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/_wp_core/wpapi/services/network_adapter.dart';
import 'package:wallpost/_wp_core/wpapi/services/network_request_executor.dart';

class Nonce extends JSONInitializable {
  late String _value;

  Nonce.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _value = sift.readStringFromMap(jsonMap, 'nonce');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast Nonce response. Error message - ${e.errorMessage}');
    }
  }

  String get value => _value;
}

class NonceProvider {
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  late String _sessionId;

  NonceProvider.initWith(this._networkAdapter);

  NonceProvider() : _networkAdapter = NetworkRequestExecutor();

  Future<Nonce> getNonce(Map<String, String> headers) async {
    var url = 'https://core.api.wallpostsoftware.com/api/v2/nonce/gen';
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addHeaders(headers);
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

  Future<Nonce> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<Nonce>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw UnexpectedResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    var sift = Sift();
    try {
      var dataMap = sift.readMapFromMap(responseMap, 'data');
      var nonce = Nonce.fromJson(dataMap);
      return nonce;
    } catch (e) {
      throw InvalidResponseException();
    }
  }
}
