import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';

import '../../../_shared/constants/app_colors.dart';

class Filter extends StatefulWidget {
  final String hint;
  final double? buttonWidth;
  final List<String> items;
  final ValueChanged<String?> onClicked ;

  Filter({
    required this.hint,
    required this.buttonWidth,
    required this.items,
    required this.onClicked

  });

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  var _selectedValueNotifier = ItemNotifier<String?>(defaultValue: null);

  @override
  Widget build(BuildContext context) {
    return ItemNotifiable<String?>(
      notifier: _selectedValueNotifier,
      builder: (context, selectedValue) {
        return CustomDropdownButton2(
          hint: widget.hint,
          hintColor: AppColors.defaultColorDark,
          hintFontSize: 16.0,
          icon: Icon(Icons.keyboard_arrow_down),
          iconSize: 24.0,
          dropdownWidth: widget.buttonWidth,
          valueAlignment: Alignment.center,
          valueColor: AppColors.defaultColorDark,
          buttonWidth: widget.buttonWidth,
          hintAlignment: Alignment.center,
          dropdownItems: widget.items,
          buttonDecoration: BoxDecoration(
              color: AppColors.dropDownColor,
              borderRadius: BorderRadius.circular(16)),
          dropdownDecoration: BoxDecoration(
              color: AppColors.dropDownColor,
              borderRadius: BorderRadius.circular(16)),
          value: selectedValue,
          onChanged: (value) {
            _selectedValueNotifier.notify(value);
            widget.onClicked(value);
          }
        );
      },
    );
  }
}
