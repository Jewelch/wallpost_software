import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/task/entities/department.dart';

class DepartmentListTile extends StatelessWidget {
  final bool isSelected;
  final Department department;
  final VoidCallback onDepartmentListTileTap;

  DepartmentListTile(
    this.isSelected,
    this.department, {
    this.onDepartmentListTileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlatButton(
          height: 50,
          child: Container(
            alignment: AlignmentDirectional.centerStart,
            child: Text(department.name,
                style: TextStyles.titleTextStyle.copyWith(
                  color: isSelected ? AppColors.defaultColor : Colors.black,
                )),
          ),
          onPressed: () {
            if (onDepartmentListTileTap != null) onDepartmentListTileTap();
          },
        ),
        Divider(height: 1),
      ],
    );
  }
}
