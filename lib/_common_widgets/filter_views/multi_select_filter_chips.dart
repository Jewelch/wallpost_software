// @dart=2.9

import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/filter_views/custom_filter_chip.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class MultiSelectFilterChipsController {
  _MultiSelectFilterChipsState _state;

  void addState(_MultiSelectFilterChipsState state) {
    _state = state;
  }

  List<int> getSelectedIndices() {
    assert(_isAttached, 'State not attached');
    return _state._selectedIndices;
  }

  void dispose() => _state = null;

  bool get _isAttached => _state != null;
}

class MultiSelectFilterChips extends StatefulWidget {
  final List<String> titles;
  final List<int> selectedIndices;
  final bool allowMultipleSelection;
  final Function(int) onItemSelected;
  final Function(int) onItemDeselected;
  final bool showTrailingButton;
  final String trailingButtonTitle;
  final VoidCallback onTrailingButtonPressed;
  final MultiSelectFilterChipsController controller;

  MultiSelectFilterChips({
    this.titles,
    this.selectedIndices,
    this.allowMultipleSelection = false,
    this.onItemSelected,
    this.onItemDeselected,
    this.showTrailingButton = false,
    this.trailingButtonTitle,
    this.onTrailingButtonPressed,
    this.controller,
  }) {
    assert(
      !(allowMultipleSelection == false && selectedIndices.length > 1),
      'Multiple selected indices passed when multiple selection is NOT ALLOWED',
    );
  }

  @override
  _MultiSelectFilterChipsState createState() =>
      _MultiSelectFilterChipsState(selectedIndices, controller: controller);
}

class _MultiSelectFilterChipsState extends State<MultiSelectFilterChips> {
  List<int> _selectedIndices;

  final MultiSelectFilterChipsController controller;

  _MultiSelectFilterChipsState(this._selectedIndices, {this.controller}) {
    if (controller != null) controller.addState(this);
  }

  @override
  void didUpdateWidget(covariant MultiSelectFilterChips oldWidget) {
    _selectedIndices.clear();
    _selectedIndices.addAll(widget.selectedIndices);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 2,
      children: List.generate(
        _getNumberOfItems(),
        (index) {
          return CustomFilterChip(
            title: Text(
                _isItemAtIndexTheTrailingButton(index)
                    ? widget.trailingButtonTitle
                    : widget.titles[index],
                style: _isSelected(index)
                    ? TextStyles.subTitleTextStyle
                        .copyWith(color: AppColors.defaultColor)
                    : TextStyles.subTitleTextStyle),
            shape: CustomFilterChipShape.roundedRectangle,
            backgroundColor: _isSelected(index)
                ? Colors.white
                : AppColors.primaryContrastColor,
            borderColor: _isSelected(index)
                ? AppColors.defaultColor
                : AppColors.primaryContrastColor,
            onPressed: _getActionForItemAtIndex(index),
          );
        },
      ),
    );
  }

  int _getNumberOfItems() {
    return widget.titles.length + (widget.showTrailingButton ? 1 : 0);
  }

  VoidCallback _getActionForItemAtIndex(int index) {
    if (_isItemAtIndexTheTrailingButton(index)) {
      return () => widget.onTrailingButtonPressed();
    } else {
      return () => _isSelected(index)
          ? _deselectItemAtIndex(index)
          : _selectItemAtIndex(index);
    }
  }

  void _selectItemAtIndex(int index) {
    setState(() {
      if (widget.allowMultipleSelection == false) _selectedIndices.clear();
      _selectedIndices.add(index);
    });
    if (widget.onItemSelected != null) widget.onItemSelected(index);
  }

  void _deselectItemAtIndex(int index) {
    setState(() => _selectedIndices.remove(index));
    if (widget.onItemDeselected != null) widget.onItemDeselected(index);
  }

  //MARK: Util functions

  bool _isSelected(int index) {
    //return false if the item is the trailing button
    if (widget.showTrailingButton && (widget.titles.length == index)) {
      return false;
    } else {
      return _selectedIndices.contains(index);
    }
  }

  bool _isItemAtIndexTheTrailingButton(int index) {
    return index == widget.titles.length && widget.showTrailingButton;
  }
}
