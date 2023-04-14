import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../_shared/constants/app_colors.dart';
import '../text_styles/text_styles.dart';
import 'custom_filter_chip.dart';

class FiltersBarController {
  FiltersBarState? _state;

  void _addState(FiltersBarState state) {
    _state = state;
  }

  void dispose() => _state = null;

  // ignore: unused_element
  bool get _isAttached => _state != null;
}

class FiltersBar extends StatefulWidget {
  final List<FilterBarItem> items;
  final bool allowMultipleSelection;
  final Function(int)? onFilterPressed;
  final Function(int)? onFilterCleared;
  final FilterBarItem? trailingButton;
  final VoidCallback? onTrailingButtonPressed;
  final FiltersBarController? controller;

  FiltersBar({
    Key? key,
    required this.items,
    this.allowMultipleSelection = false,
    this.onFilterPressed,
    this.onFilterCleared,
    this.trailingButton,
    this.onTrailingButtonPressed,
    this.controller,
  }) : super(key: key);

  @override
  FiltersBarState createState() => FiltersBarState();
}

class FiltersBarState extends State<FiltersBar> {
  FiltersBarState();

  @override
  void initState() {
    widget.controller?._addState(this);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FiltersBar oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(width: 20),
          SvgPicture.asset(
            "assets/icons/filter_icon.svg",
            width: 18,
            height: 18,
          ),
          SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 28,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  _getNumberOfItems(),
                  (index) {
                    return Container(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 0 : 12,
                        right: index == _getNumberOfItems() - 1 ? 12 : 0,
                      ),
                      child: _FilterBarChip(
                        borderColor:
                            (_isItemAtIndexTheTrailingButton(index) ? widget.trailingButton! : widget.items[index])
                                    .showBorder
                                ? AppColors.filtersBackgroundColor
                                : Colors.white,
                        title: Text(
                          _isItemAtIndexTheTrailingButton(index)
                              ? widget.trailingButton!.title
                              : widget.items[index].title,
                          style: TextStyles.subTitleTextStyleThin.copyWith(color: AppColors.textColorBlueGrayLight),
                        ),
                        icon: _isItemAtIndexTheTrailingButton(index)
                            ? widget.trailingButton!.icon
                            : widget.items[index].icon,
                        showClearButton:
                            _isItemAtIndexTheTrailingButton(index) ? false : widget.items[index].showClearButton,
                        onClearButtonPress:
                            _isItemAtIndexTheTrailingButton(index) ? null : () => widget.onFilterCleared?.call(index),
                        shape: CustomFilterChipShape.roundedRectangle,
                        onPressed: _getActionForItemAtIndex(index),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getNumberOfItems() {
    var a = widget.items.length + (widget.trailingButton != null ? 1 : 0);
    print("---------------------------");
    print("$a");
    print("---------------------------");
    return a;
  }

  VoidCallback _getActionForItemAtIndex(int index) {
    if (_isItemAtIndexTheTrailingButton(index)) {
      return () => widget.onTrailingButtonPressed?.call();
    } else {
      return () => widget.onFilterPressed?.call(index);
    }
  }

  //MARK: Util functions

  bool _isItemAtIndexTheTrailingButton(int index) {
    return index == widget.items.length && widget.trailingButton != null;
  }
}

class FilterBarItem {
  final String title;
  final Widget? icon;
  final bool showClearButton;
  final bool showBorder;

  FilterBarItem({
    required this.title,
    this.icon,
    this.showClearButton = false,
    this.showBorder = true,
  });
}

class _FilterBarChip extends StatelessWidget {
  final Text title;
  final Widget? icon;
  final bool showClearButton;
  final VoidCallback? onClearButtonPress;
  final Color borderColor;
  final CustomFilterChipShape shape;
  final VoidCallback? onPressed;

  _FilterBarChip({
    Key? key,
    required this.title,
    this.icon,
    this.showClearButton = false,
    this.onClearButtonPress,
    this.borderColor = AppColors.filtersBackgroundColor,
    this.shape = CustomFilterChipShape.roundedRectangle,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: ButtonTheme(
        minWidth: 30,
        child: MaterialButton(
          color: Colors.white,
          shape: _buildBorder(),
          onPressed: onPressed,
          elevation: 0,
          focusElevation: 0,
          highlightElevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              title,
              if (icon != null) const SizedBox(width: 8),
              if (icon != null) icon!,
              if (showClearButton) const SizedBox(width: 4),
              if (showClearButton)
                GestureDetector(
                  onTap: onClearButtonPress,
                  child: Container(
                    width: 28,
                    height: 28,
                    color: Colors.white,
                    child: Center(
                      child: Container(
                        width: 16,
                        height: 16,
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.textColorBlueGrayLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/cancel_icon.svg",
                          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  ShapeBorder _buildBorder() {
    double borderRadius = 0;
    if (shape == CustomFilterChipShape.roundedRectangle) borderRadius = 6.0;
    if (shape == CustomFilterChipShape.capsule) borderRadius = 100.0;

    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      side: BorderSide(
        color: borderColor,
        width: 1,
      ),
    );
  }
}
