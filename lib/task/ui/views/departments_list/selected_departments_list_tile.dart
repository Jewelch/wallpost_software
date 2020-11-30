import 'package:flutter/material.dart';
import 'package:wallpost/task/entities/department.dart';

class SelectedDepartmentListTile extends StatelessWidget {
  final Department department;
  final VoidCallback onDepartmentListTileTap;

  SelectedDepartmentListTile(this.department, {this.onDepartmentListTileTap});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      height: 60,
      child: Text(department.name),
      onPressed: () {
        if (onDepartmentListTileTap != null) onDepartmentListTileTap();
      },
    );
  }
}
