import 'dart:async';

import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/constants/purchase_bill_detail_urls.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/entities/purchase_bill_detail_data.dart';


class PurchaseBillDetailProvider {
  final String _companyId;
  final NetworkAdapter _networkAdapter;
  late String _sessionId;
  bool isLoading = false;

  void reset() {
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    isLoading = false;
  }

  PurchaseBillDetailProvider(this._companyId) : _networkAdapter = WPAPI();

  PurchaseBillDetailProvider.initWith(this._companyId, this._networkAdapter);

  Future<PurchaseBillDetail> get(String billId) async {
    var url = PurchaseBillDetailUrls.getPurchaseBillDetailUrl(_companyId, billId);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);

    isLoading = true;
    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      isLoading = false;
      return await _processResponse(apiResponse);
    } on WPException {
      isLoading = false;
      rethrow;
    }
  }

  Future<PurchaseBillDetail> _processResponse(APIResponse apiResponse) async {
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<PurchaseBillDetail>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    try {
      return PurchaseBillDetail.fromJson(responseMap);
    } catch (_) {
      throw InvalidResponseException();
    }
  }
}
