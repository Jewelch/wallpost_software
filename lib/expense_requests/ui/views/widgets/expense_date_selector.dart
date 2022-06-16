import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/expense_requests/ui/views/widgets/expense_input_with_header.dart';

class ExpenseDateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final void Function(DateTime) onDateSelected;

  const ExpenseDateSelector({Key? key, required this.selectedDate, required this.onDateSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var date = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime.now().subtract(Duration(days: 600)),
            lastDate: DateTime.now().add(Duration(days: 600)));
        if (date != null) onDateSelected(date);
      },
      child: ExpenseInputWithHeader(
        required: true,
        title: "Date",
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedDate.yyyyMMddString(),
                style: TextStyle(color: AppColors.darkGrey),
              ),
            ),
            SizedBox(),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.darkGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
