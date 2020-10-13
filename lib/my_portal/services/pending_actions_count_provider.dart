import 'dart:async';

import 'package:wallpost/_shared/wpapi/wp_api.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';
import 'package:wallpost/my_portal/constants/my_portal_urls.dart';
import 'package:wallpost/my_portal/entities/pending_actions_count.dart';

class PendingActionsCountProvider {
  final SelectedCompanyProvider _selectedCompanyProvider;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  String _sessionId;

  PendingActionsCountProvider()
      : _selectedCompanyProvider = SelectedCompanyProvider(),
        _networkAdapter = WPAPI();

  PendingActionsCountProvider.initWith(this._selectedCompanyProvider, this._networkAdapter);

  Future<PendingActionsCount> getCount() async {
    var company = _selectedCompanyProvider.getSelectedCompanyForCurrentUser();
    var url = MyPortalUrls.pendingActionsCountUrl(company.id);
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

  Future<PendingActionsCount> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<PendingActionsCount>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    try {
      var pendingActionsCount = PendingActionsCount.fromJson(responseMap);
      return pendingActionsCount;
    } catch (e) {
      throw InvalidResponseException();
    }
  }
}
