import 'package:flutter/material.dart';
import 'package:wallpost/expense_requests/entities/expense_request_form.dart';

class ExpenseRequestCard extends StatelessWidget {
  final ExpenseRequestForm _expenseRequest;

  ExpenseRequestCard(this._expenseRequest);

  @override
  Widget build(BuildContext context) {
    var screenWidth= MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: screenWidth * .16,
                child: Text(
                  "Date",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: screenWidth * .3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          "01.08.2019",
                        ),
                        Expanded(child: SizedBox()),
                        Icon(Icons.calendar_view_month_outlined),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    SizedBox(
                      width: 120,
                      child: Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
              IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: screenWidth * .16,
                child: Text(
                  "Category",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: DropdownButton<String>(
                  items: [],
                  onChanged: (x) {},
                  hint: Text("Choose a category"),

                  icon: Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.keyboard_arrow_down),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: screenWidth * .16,
                child: Text(
                  "Rate",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: screenWidth * .3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "81,08,2019",
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    SizedBox(
                      width: 120,
                      child: Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
              SizedBox(
                width: screenWidth * .16,
                child: Text(
                  "Quantity",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: screenWidth * .3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "1",
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    SizedBox(
                      width: 120,
                      child: Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
          SizedBox(height: 16,),
          Row(
            children: [
              SizedBox(
                width: screenWidth * .16,
                child: Text(
                  "Amount",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: screenWidth * .3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "81,08,2019",
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    SizedBox(
                      width: 120,
                      child: Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
              SizedBox(
                width: screenWidth * .16,
                child: Text(
                  "Document",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: screenWidth * .3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "4 files added",
                        ),
                        Icon(Icons.attach_file),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    SizedBox(
                      width: 120,
                      child: Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16,),
          Text(
            "Description",
            textAlign: TextAlign.start,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(

          )
        ],
      ),
    );
  }
}
