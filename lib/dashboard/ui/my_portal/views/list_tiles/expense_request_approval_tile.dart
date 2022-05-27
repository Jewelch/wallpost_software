import 'package:flutter/material.dart';
import 'package:wallpost/approvals/entities/expense_request_approval.dart';

class ExpenseRequestApprovalTile extends StatelessWidget {
  final ExpenseRequestApproval _approval;

  ExpenseRequestApprovalTile(this._approval);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 200,
      child: Text(_approval.expenseRequestNumber),
    );
  }
}