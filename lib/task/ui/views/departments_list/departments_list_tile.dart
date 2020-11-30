import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/task/entities/department.dart';

class DepartmentListTile extends StatelessWidget {
  final bool isSelected;
  final Department department;
  final VoidCallback onDepartmentListTileTap;

  DepartmentListTile(this.isSelected, this.department,
      {this.onDepartmentListTileTap});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      height: 60,
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        child: Text(department.name,
            style: TextStyle(
              color: isSelected ? AppColors.defaultColor : AppColors.blackColor,
            )),
      ),
      onPressed: () {
        if (onDepartmentListTileTap != null) onDepartmentListTileTap();
      },
    );
  }
}
