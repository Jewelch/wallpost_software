import 'package:wallpost/_wp_core/wpapi/entities/api_response.dart';
import 'package:wallpost/_wp_core/wpapi/exceptions/malformed_response_exception.dart';
import 'package:wallpost/_wp_core/wpapi/exceptions/server_sent_exception.dart';
import 'package:wallpost/_wp_core/wpapi/exceptions/unexpected_response_format_exception.dart';

class WPAPIMetaDataProcessor {
  dynamic processResponse(APIResponse response) {
    return _parseResponseData(response.data);
  }

  dynamic _parseResponseData(dynamic responseData) {
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

  dynamic _readWPResponseDataFromResponse(Map<String, dynamic> responseMap) {
    if (responseMap['status'] != 'success') {
      throw ServerSentException(responseMap['message'], responseMap['errorCode'] ?? 0);
    }


    return responseMap['metadata'];
  }

}
