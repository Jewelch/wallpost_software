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
  final AlignmentDirectional selectedItemAlignment;

  DropdownFilter({
    required this.items,
    this.selectedValue,
    this.disabledItems = const [],
    this.hint,
    this.onDidSelectItemWithValue,
    this.onDidSelectedItemAtIndex,
    this.backgroundColor = AppColors.filtersBackgroundColor,
    this.dropdownColor,
    this.textStyle,
    this.dropdownArrowColor = AppColors.defaultColorDark,
    this.selectedItemAlignment = AlignmentDirectional.centerStart,
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
            child: Text(_buildTitle(item), style: _buildTitleStyle(item), maxLines: 1),
          );
        }).toList(),
        selectedItemBuilder: (context) {
          return items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(_buildTitle(item), style: _buildTitleStyle(item), maxLines: 1),
              alignment: selectedItemAlignment,
            );
          }).toList();
        },
        style: TextStyle(overflow: TextOverflow.ellipsis),
        isExpanded: true,
        value: selectedValue,
        hint: (hint != null && hint!.isNotEmpty) ? Text(_buildTitle(hint!), style: _buildTitleStyle(hint!)) : null,
        onChanged: (selectedValue) {
          if (selectedValue == null) return;
          if (disabledItems.contains(selectedValue)) return;
          if (onDidSelectItemWithValue != null) onDidSelectItemWithValue!(selectedValue);
          if (onDidSelectedItemAtIndex != null) onDidSelectedItemAtIndex!(items.indexOf(selectedValue));
        },
        underline: SizedBox(),
        dropdownColor: dropdownColor ?? backgroundColor,
        icon: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SvgPicture.asset(
            'assets/icons/arrow_down_icon.svg',
            color: dropdownArrowColor,
            width: 14,
            height: 14,
          ),
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