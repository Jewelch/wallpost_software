import 'package:wallpost/purchase_bill/purchase_bill_approval_list/entities/purchase_bill_approval_list_item.dart';

abstract class PurchaseBillApprovalListView{
  void showLoader();

  void updateList();

  void showErrorMessage();

  void showNoItemsMessage();

  void showBillDetail(PurchaseBillApprovalBillItem approvalBillItem);

  void onDidInitiateMultipleSelection();

  void onDidEndMultipleSelection();

  void onDidProcessAllApprovals();
}