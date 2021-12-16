// @dart=2.9

import 'package:wallpost/_wp_core/wpapi/entities/api_request.dart';
import 'package:wallpost/_wp_core/wpapi/entities/api_response.dart';

export 'package:wallpost/_wp_core/wpapi/entities/api_request.dart';
export 'package:wallpost/_wp_core/wpapi/entities/api_response.dart';
export 'package:wallpost/_wp_core/wpapi/exceptions/api_exception.dart';

abstract class NetworkAdapter {
  Future<APIResponse> get(APIRequest apiRequest);

  Future<APIResponse> post(APIRequest apiRequest);

  Future<APIResponse> postWithNonce(APIRequest apiRequest);

  Future<APIResponse> put(APIRequest apiRequest);

  Future<APIResponse> delete(APIRequest apiRequest);
}
