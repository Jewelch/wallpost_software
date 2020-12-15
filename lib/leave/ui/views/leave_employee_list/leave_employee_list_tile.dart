import 'package:flutter/material.dart';
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
                style: TextStyle(
                  color: isSelected ? AppColors.defaultColor : AppColors.blackColor,
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
