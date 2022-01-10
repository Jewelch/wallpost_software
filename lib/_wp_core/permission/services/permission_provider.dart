import 'dart:async';

import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/permission/constants/permissions_urls.dart';
import 'package:wallpost/_wp_core/permission/entities/Permission.dart';
import 'package:wallpost/_wp_core/permission/repositories/permission_repository.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';

class PermissionProvider {
  final PermissionRepository _permissionRepository;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  late String _sessionId;

  PermissionProvider.initWith(this._permissionRepository, this._networkAdapter);

  PermissionProvider()
      : _permissionRepository = PermissionRepository(),
        _networkAdapter = WPAPI();

  Future<void> getPermissions() async {
    var url = PermissionsUrls.getPermissionsUrl();
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

  Future<void> _processResponse(APIResponse apiResponse) async {
    if (apiResponse.apiRequest.requestId != _sessionId)
      return Completer<void>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>)
      throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    try {
      var permission = Permission.fromJson(responseMap);
      _permissionRepository.savePermission(permission);
      return null;
    } catch (e) {
      throw InvalidResponseException();
    }
  }
}
