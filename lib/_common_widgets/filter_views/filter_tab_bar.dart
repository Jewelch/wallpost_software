// @dart=2.9

import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class FilterTabBar extends StatefulWidget {
  final TabController controller;
  final List<FilterTabBarItem> items;
  final Function(int) onTabChanged;

  FilterTabBar({this.controller, this.items, this.onTabChanged});

  @override
  _FilterTabBarState createState() => _FilterTabBarState();
}

class _FilterTabBarState extends State<FilterTabBar> {
  @override
  void initState() {
    widget.controller.addListener(() => widget.onTabChanged(widget.controller.index));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Stack(
        children: [
          Positioned(
            bottom: 1,
            left: 0,
            right: 0,
            child: Container(height: 3, color: AppColors.primaryContrastColor),
          ),
          TabBar(
            isScrollable: true,
            controller: widget.controller,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            indicatorColor: AppColors.defaultColor,
            indicatorWeight: 3,
            indicatorPadding: EdgeInsets.zero,
            tabs: widget.items,
          ),
        ],
      ),
    );
  }
}

class FilterTabBarItem extends StatelessWidget {
  final String title;
  final String count;

  const FilterTabBarItem({this.title, this.count});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Tab(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (count.isNotEmpty)
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: count,
                      style: TextStyle(
                        color: AppColors.defaultColor,
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
              ),
            if (count.isNotEmpty) SizedBox(height: 4),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: title, style: TextStyles.labelTextStyle.copyWith(color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
