import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/permission/constants/permissions_urls.dart';
import 'package:wallpost/permission/entities/request_item.dart';

class RequestItemsProvider {
  final NetworkAdapter _networkAdapter;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;

  RequestItemsProvider() : _networkAdapter = WPAPI();

  RequestItemsProvider.initWith(this._networkAdapter);

  Future<List<RequestItem>> get(String companyId) async {
    var url = PermissionsUrls.getRequestItems(companyId);
    var apiRequest = APIRequest.withId(url, _sessionId);
    isLoading = true;

    var apiResponse = await _networkAdapter.get(apiRequest);
    isLoading = false;
    return _processResponse(apiResponse);
  }

  List<RequestItem> _processResponse(APIResponse apiResponse) {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return [];

    if (apiResponse.data == null) throw InvalidResponseException();

    if (apiResponse.data is! List<Map<String, dynamic>>)
      throw WrongResponseFormatException();

    var responseMapList = apiResponse.data as List<Map<String, dynamic>>;
    return _readItemsFromResponse(responseMapList);
  }

  List<RequestItem> _readItemsFromResponse(
      List<Map<String, dynamic>> responseMapList) {
    try {
      var requestItems = <RequestItem>[];
      var eligibleItemsList = responseMapList
          .where((element) => element['visibility']! == true)
          .toList();
      for (var responseMap in eligibleItemsList) {
        var item = initializeRequestFromString(responseMap['name']!);
        if (item != null) requestItems.add(item);
      }
      return requestItems;
    } catch (e) {
      throw InvalidResponseException();
    }
  }
}
