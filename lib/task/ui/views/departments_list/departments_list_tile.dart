import 'package:flutter/material.dart';
import 'package:wallpost/task/entities/department.dart';

class DepartmentListTile extends StatelessWidget {
  final Department department;

  DepartmentListTile(this.department);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Text(department.name),
    );
  }
}
