import 'package:flutter/material.dart';
import 'package:wallpost/task/entities/task_employee.dart';

class EmployeeListTile extends StatelessWidget {
  final TaskEmployee employee;

  EmployeeListTile(this.employee);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Text(employee.fullName),
    );
  }
}
