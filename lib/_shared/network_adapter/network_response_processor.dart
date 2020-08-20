import 'dart:convert';

import 'package:dio/dio.dart';

import 'exceptions/api_exception.dart';
import 'exceptions/malformed_response_exception.dart';

class NetworkResponseProcessor {
  dynamic processResponse(Response response) {
    if (_didSucceed(response)) {
      var responseData = _parseResponseString(response.data);
      return _parseResponseData(responseData);
    } else {
      throw HTTPException(response.statusCode);
    }
  }

  bool _didSucceed(Response response) {
    return response.statusCode == 200;
  }

  dynamic _parseResponseString(String responseString) {
    try {
      return json.decode(responseString);
    } catch (e) {
      throw WrongResponseFormatException();
    }
  }

  dynamic _parseResponseData(dynamic responseData) {
    if (responseData is! Map<String, dynamic>) {
      throw WrongResponseFormatException();
    }

    var responseMap = responseData as Map<String, dynamic>;

    if (_isResponseProperlyFormed(responseMap) == false) {
      throw MalformedResponseException();
    }

    if (responseMap['status'] == 'success') {
      return responseMap['data'];
    } else {
      throw ServerSentException(responseMap['message'], responseMap['errorCode'] ?? 0);
    }
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
}
