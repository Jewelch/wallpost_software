import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/leave/entities/leave_employee.dart';

class EmployeeListTile extends StatelessWidget {
  final bool isSelected;
  final LeaveEmployee employee;
  final VoidCallback onEmployeeListTileTap;

  EmployeeListTile(
    this.isSelected,
    this.employee, {
    this.onEmployeeListTileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlatButton(
          height: 50,
          child: Container(
            alignment: AlignmentDirectional.centerStart,
            child: Text(employee.fullName,
                style: TextStyles.titleTextStyle.copyWith(
                  color: isSelected ? AppColors.defaultColor : Colors.black,
                )),
          ),
          onPressed: () {
            if (onEmployeeListTileTap != null) onEmployeeListTileTap();
          },
        ),
        Divider(height: 1),
      ],
    );
  }
}
