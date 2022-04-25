import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/expense_list/entities/expense_request.dart';

class ExpenseListItem extends StatelessWidget {
  final ExpenseRequest? _expenseRequest;

  const ExpenseListItem(this._expenseRequest, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: AppColors.primaryContrastColor,
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
                  "New Laptop for",
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
                    style: TextStyle(fontSize: 14, color: AppColors.labelColor),
                  ),
                  Text(
                    " 3500",
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
                      "Request No -",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.labelColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Expanded(
                      child: Text(
                        " 19/00072",
                        style: TextStyle(fontSize: 14, color: AppColors.labelColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    "Date -",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.labelColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    " 12 Dec 2021",
                    style: TextStyle(fontSize: 14, color: AppColors.labelColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
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
                      "Request by -",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.labelColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Expanded(
                      child: Text(
                        " Abdelrahman mohamed hassan mohamed",
                        style: TextStyle(fontSize: 14, color: AppColors.labelColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_ios_sharp,color: AppColors.labelColor,size: 16,))
              //   ],
              // ),
              // IconButton(onPressed: () {}, icon:
              Icon(Icons.arrow_forward_ios_sharp,color: AppColors.labelColor,size: 16,)
              // )

            ],
          ),
          Text("Approved",style: TextStyle(color: AppColors.pendingApprovalColor),)
        ],
      ),
    );
  }
}
