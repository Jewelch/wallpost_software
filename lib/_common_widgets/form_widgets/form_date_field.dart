import 'package:flutter/material.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';

import '../../_shared/constants/app_colors.dart';
import '../keyboard_dismisser/keyboard_dismisser.dart';
import '../text_styles/text_styles.dart';

class FormDateField extends StatelessWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime) onDateSelected;
  final String? errorText;

  FormDateField({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            KeyboardDismisser.dismissKeyboard();
            var date = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: firstDate,
              lastDate: lastDate,
            );
            if (date != null) onDateSelected(date);
          },
          child: Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.textFieldBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(child: Text(initialDate.toReadableString(), style: TextStyles.titleTextStyle)),
                Icon(Icons.calendar_today_outlined, color: AppColors.textColorGray),
              ],
            ),
          ),
        ),
        SizedBox(height: 4),
        if (errorText != null && errorText!.isNotEmpty)
          Text("    ${errorText!}", style: TextStyle(fontSize: 14, color: AppColors.red))
      ],
    );
  }
}
