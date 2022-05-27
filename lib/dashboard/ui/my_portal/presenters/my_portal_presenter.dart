
import 'package:wallpost/dashboard/ui/my_portal/view_contracts/my_portal_view.dart';
import '../../../../_shared/exceptions/wp_exception.dart';
import '../../../../_wp_core/user_management/services/current_user_provider.dart';
import '../../../../approvals/entities/approval.dart';
import '../../../../approvals/services/approval_list_provider.dart';

class MyPortalPresenter {
  final MyPortalView _view;
  final CurrentUserProvider _currentUserProvider;
  final ApprovalListProvider _provider;
  String? _errorMessage;
  List approvals = [];

  MyPortalPresenter(this._view)
      : _currentUserProvider = CurrentUserProvider(),
        _provider = ApprovalListProvider();

  MyPortalPresenter.initWith(
      this._view, this._currentUserProvider, this._provider);

  String getProfileImageUrl() {
    return _currentUserProvider.getCurrentUser().profileImageUrl;
  }

  Future<void> loadApprovals() async {
    if (_provider.isLoading || _provider.didReachListEnd) return;


    try {
      var approvalsList = await _provider.getNext();
      approvals.addAll(approvalsList);
      _view.onDidLoadData();
      _view.onDidLoadApprovals(approvalsList);
     // _view.onDidLoadActionsCount(_provider.actionsCount);
    } on WPException catch (e) {
      _errorMessage = e.userReadableMessage;
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
    }
  }

  refresh() {
    _provider.reset();
    loadApprovals();
  }

  int getNumberOfItems() {
    if (_hasErrors()) return approvals.length + 1;

    if (approvals.isEmpty) return 1;

    if (_provider.didReachListEnd) {
      return approvals.length;
    } else {
      return approvals.length + 1;
    }
  }

  void _resetErrors() {
    _errorMessage = null;
  }

  bool _hasErrors() {
    return _errorMessage != null;
  }

  String getApprovalType(Approval approval) {
    // switch (approval.approvalType) {
    //   case "leaveApproval":
    //     return "Leave Approval";
    //   case "expenseRequestApproval":
    //     return "Expense Request Approval";
    //   case "attendanceAdjustment":
    //     return "Attendance Adjustment";
    // }
    return "";
  }

  String createdBy(Approval approval) {
    // switch (approval.approvalType) {
    //   case "leaveApproval":
    //     return "la";//approval.leaveDetails!.approveRequestBy!;
    //   case "expenseRequestApproval":
    //     return "er";//approval.expenseRequestApprovalDetails!.createdByName!;
    //   case "attendanceAdjustment":
    //     return "a";//approval.attendanceAdjustmentDetail!.name!;
    // }
    return "";
  }

  String valueOf(Approval approval) {
    // switch (approval.approvalType) {
    //   case "leaveApproval":
    //     return "lv";//'${approval.leaveDetails!.leaveDays.toString()} days';
    //   case "expenseRequestApproval":
    //     return "erv";//'\$ ${approval.expenseRequestApprovalDetails!.totalAmount!} ';
    //   case "attendanceAdjustment":
    //     return "aav";//approval.attendanceAdjustmentDetail!.reason!;
    // }
    return "";
  }







}
