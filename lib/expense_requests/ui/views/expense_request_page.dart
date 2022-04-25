import 'package:flutter/material.dart';
import 'package:notifiable/notifiable.dart';
import 'package:wallpost/expense_requests/entities/expense_request_form.dart';
import 'package:wallpost/expense_requests/ui/views/per_expense_request_card.dart';

class ExpenseRequestPage extends StatelessWidget {
  final Notifier expenseRequestsNotifier = Notifier();
  final List<ExpenseRequestForm> expenseRequests = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Expense Request",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.blueAccent,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            onPressed: _onSubmit,
            icon: Icon(
              Icons.check,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(width: MediaQuery.of(context).size.width,padding: EdgeInsets.only(left: 8),height: 30,color: Colors.grey[200],child: Align(alignment: Alignment.centerLeft,child: Text("Net Amount"))),
          ...expenseRequests.map((e) => ExpenseRequestCard(e)).toList()
        ],
      ),
    );
  }

  void _onSubmit() {}
}
