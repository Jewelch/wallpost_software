import 'package:wallpost/_shared/network_adapter/entities/api_response.dart';
import 'package:wallpost/_shared/network_adapter/exceptions/malformed_response_exception.dart';
import 'package:wallpost/_shared/network_adapter/exceptions/server_sent_exception.dart';
import 'package:wallpost/_shared/network_adapter/exceptions/wrong_response_format_exception.dart';

class WPAPIResponseProcessor {
  dynamic processResponse(APIResponse response) {
    return _parseResponseData(response.data);
  }

  dynamic _parseResponseData(dynamic responseData) {
    if (responseData is! Map<String, dynamic>) {
      throw WrongResponseFormatException();
    }

    var responseMap = responseData as Map<String, dynamic>;

    if (_isResponseProperlyFormed(responseMap) == false) {
      throw MalformedResponseException();
    }

    return _readWPResponseDataFromResponse(responseMap);
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

    if ((responseMap['data'] is List<dynamic>)) {
      return _parseDataList(responseMap['data']);
    } else {
      return responseMap['data'];
    }
  }

  List<Map<String, dynamic>> _parseDataList(List<dynamic> responseDataList) {
    List<Map<String, dynamic>> items = [];

    responseDataList.forEach((element) {
      if (element is Map<String, dynamic>) {
        items.add(element);
      } else {
        return [];
      }
    });
    return items;
  }
}
