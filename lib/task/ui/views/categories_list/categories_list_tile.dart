import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/task/entities/task_category.dart';

class CategoryListTile extends StatelessWidget {
  final bool isSelected;
  final TaskCategory taskCategory;
  final VoidCallback onCategoryListTileTap;

  CategoryListTile(
    this.isSelected,
    this.taskCategory, {
    this.onCategoryListTileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlatButton(
          height: 50,
          child: Container(
            alignment: AlignmentDirectional.centerStart,
            child: Text(taskCategory.name,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.defaultColor
                      : Colors.black,
                )),
          ),
          onPressed: () {
            if (onCategoryListTileTap != null) onCategoryListTileTap();
          },
        ),
        Divider(height: 1),
      ],
    );
  }
}
