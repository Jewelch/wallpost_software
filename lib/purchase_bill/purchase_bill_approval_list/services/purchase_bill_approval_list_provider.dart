import 'dart:async';

import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval_list/constants/purchase_bill_approval_list_urls.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval_list/entities/purchase_bill_approval_list_item.dart';

import '../../../_wp_core/wpapi/services/wp_api.dart';

class PurchaseBillApprovalListProvider {
  final String _companyId;
  final NetworkAdapter _networkAdapter;
  final int _perPage = 15;
  int _pageNumber = 1;
  bool _didReachListEnd = false;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;

  PurchaseBillApprovalListProvider.initWith(this._companyId, this._networkAdapter);

  PurchaseBillApprovalListProvider(this._companyId) : _networkAdapter = WPAPI();

  void reset() {
    _pageNumber = 1;
    _didReachListEnd = false;
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    isLoading = false;
  }

  Future<List<PurchaseBillApprovalListItem>> getNext() async {
    var url = PurchaseBillApprovalListUrls.pendingApprovalListUrl(_companyId, _pageNumber, _perPage);
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

  Future<List<PurchaseBillApprovalListItem>> _processResponse(APIResponse apiResponse) async {
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<PurchaseBillApprovalListItem>>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! List<Map<String, dynamic>>) throw WrongResponseFormatException();

    var responseMapList = apiResponse.data as List<Map<String, dynamic>>;
    return _readItemsFromResponse(responseMapList);
  }

  List<PurchaseBillApprovalListItem> _readItemsFromResponse(List<Map<String, dynamic>> responseMapList) {
    try {
      var approvalList = <PurchaseBillApprovalListItem>[];
      for (var responseMap in responseMapList) {
        var approval = PurchaseBillApprovalListItem.fromJson(responseMap);
        approvalList.add(approval);
      }
      _updatePaginationRelatedData(approvalList.length);
      return approvalList;
    } catch (_) {
      throw InvalidResponseException();
    }
  }

  void _updatePaginationRelatedData(int noOfItemsReceived) {
    if (noOfItemsReceived > 0) {
      _pageNumber += 1;
    }
    if (noOfItemsReceived < _perPage) {
      _didReachListEnd = true;
    }
  }

  int getCurrentPageNumber() {
    return _pageNumber;
  }

  bool get didReachListEnd => _didReachListEnd;
}
