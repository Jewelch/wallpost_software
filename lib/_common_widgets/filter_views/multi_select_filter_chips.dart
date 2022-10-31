import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/filter_views/custom_filter_chip.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class MultiSelectFilterChipsController {
  _MultiSelectFilterChipsState? _state;

  void addState(_MultiSelectFilterChipsState state) {
    _state = state;
  }

  List<int> getSelectedIndices() {
    assert(_isAttached, 'State not attached');
    return _state?._selectedIndices ?? [];
  }

  void dispose() => _state = null;

  bool get _isAttached => _state != null;
}

class MultiSelectFilterChips extends StatefulWidget {
  final List<String> titles;
  final List<int> selectedIndices;
  final bool allowMultipleSelection;
  final Function(int)? onItemSelected;
  final Function(int)? onItemDeselected;
  final bool showTrailingButton;
  final String? trailingButtonTitle;
  final VoidCallback? onTrailingButtonPressed;
  final MultiSelectFilterChipsController? controller;

  MultiSelectFilterChips({
    required this.titles,
    required this.selectedIndices,
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
  _MultiSelectFilterChipsState createState() => _MultiSelectFilterChipsState(selectedIndices, controller: controller);
}

class _MultiSelectFilterChipsState extends State<MultiSelectFilterChips> {
  List<int> _selectedIndices;

  final MultiSelectFilterChipsController? controller;

  _MultiSelectFilterChipsState(this._selectedIndices, {this.controller}) {
    controller?.addState(this);
  }

  @override
  void didUpdateWidget(covariant MultiSelectFilterChips oldWidget) {
    _selectedIndices.clear();
    _selectedIndices.addAll(widget.selectedIndices);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(
        _getNumberOfItems(),
        (index) {
          return Container(
            padding: EdgeInsets.only(left: 12, right: index == _getNumberOfItems() - 1 ? 12 : 0),
            child: CustomFilterChip(
              title: Text(_isItemAtIndexTheTrailingButton(index) ? widget.trailingButtonTitle! : widget.titles[index],
                  style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.defaultColorDark)),
              shape: CustomFilterChipShape.roundedRectangle,
              backgroundColor: AppColors.filtersBackgroundColor,
              borderColor: _isSelected(index) ? AppColors.defaultColorDark : AppColors.filtersBackgroundColor,
              onPressed: _getActionForItemAtIndex(index),
            ),
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
      return () => widget.onTrailingButtonPressed?.call();
    } else {
      return () => _isSelected(index) ? _deselectItemAtIndex(index) : _selectItemAtIndex(index);
    }
  }

  void _selectItemAtIndex(int index) {
    setState(() {
      if (widget.allowMultipleSelection == false) _selectedIndices.clear();
      _selectedIndices.add(index);
    });
    widget.onItemSelected?.call(index);
  }

  void _deselectItemAtIndex(int index) {
    setState(() => _selectedIndices.remove(index));
    widget.onItemDeselected?.call(index);
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
