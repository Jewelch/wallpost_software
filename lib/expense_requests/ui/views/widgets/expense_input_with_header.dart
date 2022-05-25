import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

Widget expenseInputWithHeader({
  required String title,
  required Widget child,
  double height = 48,
  bool required = false,
  bool showRequiredMessage = false,
}) {
  return Column(children: [
    Row(
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        if (required) Text("  *", style: TextStyle(color: Colors.red)),
        if (showRequiredMessage) Text("  this field is required", style: TextStyle(color: Colors.red)),
      ],
    ),
    SizedBox(height: 8),
    Container(
      height: height,
      decoration: BoxDecoration(color: AppColors.textFieldBackgroundColor, borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: child,
      ),
    ),
    SizedBox(height: 16),
  ]);
}
