import 'package:wallpost/approvals_list/services/approvals_aggregated_list_provider.dart';
import 'package:wallpost/dashboard/ui/my_portal/view_contracts/my_portal_view.dart';
import '../../../../_shared/exceptions/wp_exception.dart';
import '../../../../_wp_core/user_management/services/current_user_provider.dart';
import '../../../../approvals_list/entities/approval_aggregated.dart';

class MyPortalPresenter {
  final MyPortalView _view;
  final CurrentUserProvider _currentUserProvider;
   final ApprovalsAggregatedListProvider _approvalsAggregatedListProvider;


  List<ApprovalAggregated> approvals = [];
  String _errorMessage = "";
  String? companyId ="";

  MyPortalPresenter(this._view)
      : _currentUserProvider = CurrentUserProvider(),
        _approvalsAggregatedListProvider = ApprovalsAggregatedListProvider();

  MyPortalPresenter.initWith(
      this._view, this._currentUserProvider, this._approvalsAggregatedListProvider);

  String getProfileImageUrl() {
    return _currentUserProvider.getCurrentUser().profileImageUrl;
  }

  Future<void> loadApprovalsList(String? companyId) async {
    this.companyId = companyId ;
    if (_approvalsAggregatedListProvider.isLoading) return;
    if (approvals.isEmpty) _view.onLoad();

    try {
      var approvalsList = await _approvalsAggregatedListProvider.get(companyId);

      approvals.addAll(approvalsList);
      _resetErrors();


      showApprovalsList(approvals);
    } on WPException catch (e) {
      approvals.clear();
      _errorMessage = '${e.userReadableMessage}\n\nTap here to reload.';
      _view.showErrorMessage(_errorMessage);
    }
  }

  void showApprovalsList(List<ApprovalAggregated> approvals) {
    if (approvals.isNotEmpty) {
      _view.onDidLoadApprovals(approvals);
      _view.onDidLoadActionsCount(approvals.length);
    } else {
      _view.showErrorMessage("There are no approvals.\n\nTap here to reload.");
    }
  }

  refresh() {
    _approvalsAggregatedListProvider.reset();
    loadApprovalsList(this.companyId);
  }

  void _resetErrors() {
    _errorMessage = "";
  }


}
