import 'package:wallpost/_wp_core/wpapi/entities/api_response.dart';
import 'package:wallpost/_wp_core/wpapi/exceptions/malformed_response_exception.dart';
import 'package:wallpost/_wp_core/wpapi/exceptions/server_sent_exception.dart';
import 'package:wallpost/_wp_core/wpapi/exceptions/unexpected_response_format_exception.dart';

class WPAPIResponseProcessor {
  Map<String, dynamic> processResponse(APIResponse response) {
    return _parseResponseData(response.data);
  }

  Map<String, dynamic> _parseResponseData(dynamic responseData) {
    if (responseData is! Map<String, dynamic>) {
      throw UnexpectedResponseFormatException();
    }

    if (_isResponseProperlyFormed(responseData) == false) {
      throw MalformedResponseException();
    }

    return _readWPResponseDataFromResponse(responseData);
  }

  bool _isResponseProperlyFormed(Map<String, dynamic> responseMap) {
    if (responseMap.containsKey('status')) {
      if (responseMap['status'] == 'success') {
        return responseMap.containsKey('data');
      } else {
        return true;
      }
    }
    return false;
  }

  Map<String, dynamic> _readWPResponseDataFromResponse(Map<String, dynamic> responseMap) {
    if (responseMap['status'] != 'success') {
      throw ServerSentException(responseMap['message'], responseMap['errorCode'] ?? 0);
    }

    dynamic response;
    if ((responseMap['data'] is List<dynamic>)) {
      response = _parseDataList(responseMap['data']);
    } else {
      response = responseMap['data'];
    }

    Map<String, dynamic> processedResponse = {};
    processedResponse["response"] = response;
    processedResponse["metadata"] = _parseMetadata(responseMap);
    return processedResponse;
  }

  List<Map<String, dynamic>> _parseDataList(List<dynamic> responseDataList) {
    List<Map<String, dynamic>> items = [];

    for (dynamic element in responseDataList) {
      if (element is Map<String, dynamic>) {
        items.add(element);
      } else {
        items.clear();
        break;
      }
    }
    return items;
  }

  Map<String, dynamic>? _parseMetadata(Map<String, dynamic> responseMap) {
    var metadata = responseMap["metadata"];

    if (metadata == null) return null;
    if (!(metadata is Map<String, dynamic>)) return null;
    return metadata;
  }
}
