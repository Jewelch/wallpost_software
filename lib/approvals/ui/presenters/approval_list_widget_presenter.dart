import 'package:wallpost/approvals/services/approval_list_provider.dart';
import 'package:wallpost/approvals/ui/view_contracts/approval_list_widget_view.dart';

class ApprovalListWidgetPresenter {
  final ApprovalListWidgetView _view;
  final ApprovalListProvider _listProvider;

  ApprovalListWidgetPresenter(this._view) : _listProvider = ApprovalListProvider();

  void getNextListOfApprovals() async {
    var approvals = await _listProvider.getNext();
    _view.onDidLoadApprovals(approvals);
  }
}
