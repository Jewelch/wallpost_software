import 'dart:async';

import 'package:sift/sift.dart';
import 'package:wallpost/_common_widgets/app_badge/app_badge.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/dashboard/group_dashboard/constants/group_dashboard_urls.dart';
import 'package:wallpost/dashboard/group_dashboard/entities/group_dashboard_data.dart';

class GroupDashboardDataProvider {
  final NetworkAdapter _networkAdapter;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;
  final AppBadge _appBadge;

  GroupDashboardDataProvider.initWith(this._networkAdapter, this._appBadge);

  GroupDashboardDataProvider()
      : _networkAdapter = WPAPI(),
        _appBadge = AppBadge();

  Future<GroupDashboardData> get() async {
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var url = GroupDashboardUrls.getGroupDashboardUrl();
    var apiRequest = APIRequest.withId(url, _sessionId);
    _isLoading = true;

    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      _isLoading = false;
      return _processResponse(apiResponse);
    } on APIException catch (exception) {
      _isLoading = false;
      throw exception;
    }
  }

  Future<GroupDashboardData> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<GroupDashboardData>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    try {
      updateBadgeNumber(responseMap);
      return GroupDashboardData.fromJson(responseMap);
    } on MappingException catch (_) {
      throw InvalidResponseException();
    }
  }

  void updateBadgeNumber(Map<String, dynamic> responseMap) {
    var companyMapList = Sift().readMapListFromMap(responseMap, "companies");
    var count = _readCount(companyMapList);
    _appBadge.updateAppBadge(count);
  }

  int _readCount(List<Map<String, dynamic>> companyMapList) {
    int approvalCount = 0;
    for (var map in companyMapList) {
      var companyApprovalCount = Sift().readNumberFromMap(map, 'companyApprovalCount').toInt();
      approvalCount += companyApprovalCount;
    }
    return approvalCount;
  }

  bool get isLoading => _isLoading;
}
