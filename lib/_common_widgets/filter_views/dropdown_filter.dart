import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../_shared/constants/app_colors.dart';

class DropdownFilter extends StatelessWidget {
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String>? onDidSelectItemWithValue;
  final ValueChanged<int>? onDidSelectedItemAtIndex;

  DropdownFilter({
    required this.items,
    this.selectedValue,
    this.onDidSelectItemWithValue,
    this.onDidSelectedItemAtIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.filtersBackgroundColour,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item, style: TextStyle(color: AppColors.defaultColorDark, overflow: TextOverflow.ellipsis)),
          );
        }).toList(),
        isExpanded: true,
        value: selectedValue,
        style: TextStyle(overflow: TextOverflow.fade),
        onChanged: (selectedValue) {
          if (selectedValue == null) return;
          if (onDidSelectItemWithValue != null) onDidSelectItemWithValue!(selectedValue);
          if (onDidSelectedItemAtIndex != null) onDidSelectedItemAtIndex!(items.indexOf(selectedValue));
        },
        underline: SizedBox(),
        dropdownColor: AppColors.filtersBackgroundColour,
        icon: SvgPicture.asset(
          'assets/icons/arrow_down_icon.svg',
          color: AppColors.defaultColorDark,
          width: 14,
          height: 14,
        ),
      ),
    );
  }
}
