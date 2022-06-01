import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class ExpenseInputWithHeader extends StatelessWidget {
  final String title;
  final Widget child;
  final double height;
  final bool required;
  final String missingMessage;

  const ExpenseInputWithHeader(
      {required this.title,
      required this.child,
      this.height = 48,
      this.required = false,
      this.missingMessage = "",
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          if (required) Text("  *", style: TextStyle(color: Colors.red)),
          Expanded(child: Text("  $missingMessage", style: TextStyle(color: Colors.red),overflow: TextOverflow.ellipsis,)),
        ],
      ),
      SizedBox(height: 8),
      Container(
        height: height,
        decoration: BoxDecoration(
            color: AppColors.textFieldBackgroundColor, borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: child,
        ),
      ),
      SizedBox(height: 16),
    ]);
  }
}
