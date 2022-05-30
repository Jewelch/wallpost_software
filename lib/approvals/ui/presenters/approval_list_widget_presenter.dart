import 'package:wallpost/approvals/services/approval_list_provider.dart';
import 'package:wallpost/approvals/ui/view_contracts/approval_list_widget_view.dart';

import '../../../_shared/exceptions/wp_exception.dart';

class ApprovalListWidgetPresenter {
  final ApprovalListWidgetView _view;
  final ApprovalListProvider _provider;
  List approvals = [];
  String? _errorMessage;

  ApprovalListWidgetPresenter(this._view) : _provider = ApprovalListProvider();

  ApprovalListWidgetPresenter.initWith(this._view, this._provider);

  Future<void> loadApprovals() async {
    if (_provider.isLoading || _provider.didReachListEnd) return;

    try {
      var approvalsList = await _provider.getNext();
      approvals.addAll(approvalsList);

      _view.onDidLoadData();
      _view.onDidLoadActionsCount(_provider.actionsCount);
      _view.onDidLoadApprovals(approvalsList);
    } on WPException catch (e) {
      _errorMessage = e.userReadableMessage;
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
    }
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

  refresh() {
    _provider.reset();
    loadApprovals();
  }

  void _resetErrors() {
    _errorMessage = null;
  }

  bool _hasErrors() {
    return _errorMessage != null;
  }

  bool isEmpty() {
    return approvals.isEmpty;
  }
}
