import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';

class ExpenseDateSelector extends StatelessWidget {
  final void Function(DateTime) onDateSelected;

  const ExpenseDateSelector({Key? key, required this.onDateSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 600)));
        if (date != null) onDateSelected(date);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              DateTime.now().yyyyMMddString(),
              style: TextStyle(color: AppColors.darkGrey),
            ),
          ),
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
    );
  }
}
