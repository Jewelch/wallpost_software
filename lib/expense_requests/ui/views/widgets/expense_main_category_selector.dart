import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/expense_requests/entities/expense_category.dart';

class ExpenseCategorySelector extends StatefulWidget {
  final List<ExpenseCategory> items;
  final void Function(ExpenseCategory?) onChanged;
  final ExpenseCategory? Function() value;

  const ExpenseCategorySelector(
      {Key? key, required this.items, required this.onChanged, required this.value})
      : super(key: key);

  @override
  State<ExpenseCategorySelector> createState() => _ExpenseCategorySelectorState();
}

class _ExpenseCategorySelectorState extends State<ExpenseCategorySelector> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<ExpenseCategory>(
      items: widget.items
          .map((category) => DropdownMenuItem(value: category, child: Text(category.name)))
          .toList(),
      onChanged: (mainCategory) {
        widget.onChanged(mainCategory);
        setState(() {});
      },
      icon: Icon(
        Icons.arrow_forward_ios_sharp,
        color: AppColors.darkGrey,
      ),
      alignment: Alignment.centerRight,
      value: widget.value(),
      underline: SizedBox(),
      isExpanded: true,
      style: TextStyle(color: AppColors.darkGrey),
    );
  }
}
