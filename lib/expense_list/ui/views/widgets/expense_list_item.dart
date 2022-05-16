import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/expense_list/entities/expense_request.dart';
import 'package:wallpost/expense_list/entities/expense_request_status.dart';

class ExpenseListItem extends StatelessWidget {
  final ExpenseRequest _expenseRequest;

  const ExpenseListItem(this._expenseRequest, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        padding: EdgeInsets.all(8),
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 1,
            color: AppColors.textFieldBackgroundColor,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _expenseRequest.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "QAR",
                      style: TextStyle(fontSize: 14, color: AppColors.textGrey),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      _expenseRequest.totalAmount.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        "Request No - ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.darkGrey),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Expanded(
                        child: Text(
                          _expenseRequest.requestNo,
                          style: TextStyle(fontSize: 14, color: AppColors.textGrey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Date -",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.darkGrey),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _expenseRequest.createdAt.yyyyMMddString(),
                        style: TextStyle(fontSize: 14, color: AppColors.textGrey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        "Request by - ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.darkGrey),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Expanded(
                        child: Text(
                          _expenseRequest.createdBy,
                          style: TextStyle(fontSize: 14, color: AppColors.textGrey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: AppColors.darkGrey,
                  size: 16,
                )
                // )
              ],
            ),
            _getStatusText()
          ],
        ),
      ),
    );
  }

  Text _getStatusText() {
    Color color;
    switch (_expenseRequest.status) {
      case ExpenseRequestStatus.approved:
        color = AppColors.successColor;
        break;
      case ExpenseRequestStatus.pending:
        color = AppColors.yellow;
        break;
      case ExpenseRequestStatus.rejected:
        color = AppColors.failureColor;
        break;
    }
    return Text(
      _expenseRequest.status.toReadableString(),
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }
}
