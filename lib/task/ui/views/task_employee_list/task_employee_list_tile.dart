import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/task/entities/task_employee.dart';

class EmployeeListTile extends StatelessWidget {
  final bool isSelected;
  final TaskEmployee employee;
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
                style: TextStyle(
                  color: isSelected
                      ? AppColors.defaultColor
                      : AppColors.blackColor,
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
