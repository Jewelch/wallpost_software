import 'package:flutter/material.dart';
import 'package:wallpost/task/entities/task_category.dart';

class CategoryListTile extends StatelessWidget {
  final TaskCategory category;

  CategoryListTile(this.category);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Text(category.name),
    );
  }
}
