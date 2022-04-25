import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';

class DateSelector extends StatelessWidget {
  final void Function(DateTime) onDateSelected;

  const DateSelector({Key? key, required this.onDateSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateTime.now().yyyyMMddString(),
            style: TextStyle(color: AppColors.darkGrey),
          ),
          IconButton(
            onPressed: () async {
              var date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 600)));
              if (date != null) onDateSelected(date);
            },
            icon: Icon(
              Icons.calendar_today_outlined,
              color: AppColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }
}
