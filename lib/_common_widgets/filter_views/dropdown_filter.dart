import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../_shared/constants/app_colors.dart';

class DropdownFilter extends StatelessWidget {
  final List<String> items;
  final String? selectedValue;
  final List<String> disabledItems;
  final String? hint;
  final ValueChanged<String>? onDidSelectItemWithValue;
  final ValueChanged<int>? onDidSelectedItemAtIndex;
  final Color backgroundColor;
  final Color? dropdownColor;
  final TextStyle? textStyle;
  final Color? dropdownArrowColor;

  DropdownFilter({
    required this.items,
    this.selectedValue,
    this.disabledItems = const [],
    this.hint,
    this.onDidSelectItemWithValue,
    this.onDidSelectedItemAtIndex,
    this.backgroundColor = AppColors.filtersBackgroundColour,
    this.dropdownColor,
    this.textStyle,
    this.dropdownArrowColor = AppColors.defaultColorDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(_buildTitle(item), style: _buildTitleStyle(item)),
          );
        }).toList(),
        isExpanded: true,
        value: selectedValue,
        style: TextStyle(overflow: TextOverflow.fade),
        hint: (hint != null && hint!.isNotEmpty) ? Text(_buildTitle(hint!), style: _buildTitleStyle(hint!)) : null,
        onChanged: (selectedValue) {
          if (selectedValue == null) return;
          if (disabledItems.contains(selectedValue)) return;
          if (onDidSelectItemWithValue != null) onDidSelectItemWithValue!(selectedValue);
          if (onDidSelectedItemAtIndex != null) onDidSelectedItemAtIndex!(items.indexOf(selectedValue));
        },
        underline: SizedBox(),
        dropdownColor: dropdownColor ?? backgroundColor,
        icon: SvgPicture.asset(
          'assets/icons/arrow_down_icon.svg',
          color: dropdownArrowColor,
          width: 14,
          height: 14,
        ),
      ),
    );
  }

  String _buildTitle(String item) {
    return item + "${_isItemDisabled(item) ? " (Disabled)" : ""}";
  }

  TextStyle _buildTitleStyle(String item) {
    var style = textStyle ?? TextStyle(color: AppColors.defaultColorDark, overflow: TextOverflow.ellipsis);
    if (_isItemDisabled(item)) style = style.copyWith(color: AppColors.textColorGray);
    return style;
  }

  bool _isItemDisabled(String item) {
    return disabledItems.contains(item);
  }
}
