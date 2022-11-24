import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/filter_views/custom_filter_chip.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class TabChips extends StatefulWidget {
  final List<String> titles;
  final Function(int)? onItemSelected;
  final Color chipBackgroundColor;
  final Color titleColor;

  TabChips({
    required this.titles,
    this.onItemSelected,
    this.chipBackgroundColor = AppColors.filtersBackgroundColor,
    this.titleColor = AppColors.defaultColorDark,
  });

  @override
  _TabChipsState createState() => _TabChipsState();
}

class _TabChipsState extends State<TabChips> {
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
              title: Text(
                widget.titles[index],
                style: TextStyles.subTitleTextStyle.copyWith(color: widget.titleColor),
              ),
              shape: CustomFilterChipShape.roundedRectangle,
              backgroundColor: widget.chipBackgroundColor,
              borderColor: widget.chipBackgroundColor,
              onPressed: () {
                widget.onItemSelected?.call(index);
              },
            ),
          );
        },
      ),
    );
  }

  int _getNumberOfItems() {
    return widget.titles.length;
  }
}
