import 'dart:async';

import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/permission/constants/permissions_urls.dart';
import 'package:wallpost/permission/entities/wp_action.dart';
import 'package:wallpost/permission/repositories/request_items_repository.dart';

class AllowedWPActionsProvider {
  final NetworkAdapter _networkAdapter;
  final RequestItemsRepository _repository;
  late String _sessionId;

  bool isLoading = false;

  AllowedWPActionsProvider()
      : _networkAdapter = WPAPI(),
        _repository = RequestItemsRepository();

  AllowedWPActionsProvider.initWith(this._networkAdapter, this._repository);

  Future<void> get(String companyId) async {
    var url = PermissionsUrls.getRequestItemsUrl(companyId);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    isLoading = true;

    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      isLoading = false;
      await _processResponse(apiResponse, companyId);
    } on WPException {
      isLoading = false;
      rethrow;
    }
  }

  Future<void> _processResponse(APIResponse apiResponse, String companyId) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<void>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! List<Map<String, dynamic>>) throw WrongResponseFormatException();

    var responseMapList = apiResponse.data as List<Map<String, dynamic>>;
    var requestItems = _readItemsFromResponse(responseMapList);
    await _repository.saveRequestItemsForEmployee(companyId, requestItems);
  }

  List<WPAction> _readItemsFromResponse(List<Map<String, dynamic>> responseMapList) {
    try {
      var requestItems = <WPAction>[];
      var eligibleItemsList = responseMapList.where((element) => element['visibility']! == true).toList();
      for (var responseMap in eligibleItemsList) {
        var item = initializeRequestFromString(responseMap['name']!);
        if (item != null) requestItems.add(item);
      }
      return requestItems;
    } catch (e) {
      isLoading = false;
      throw InvalidResponseException();
    }
  }
}
