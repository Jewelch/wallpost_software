import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class FilterTabBar extends StatelessWidget {
  final TabController tabController;
  final List<FilterTabBarItem> items;

  FilterTabBar({this.tabController, this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
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
            controller: tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            indicatorColor: AppColors.defaultColor,
            indicatorWeight: 3,
            indicatorPadding: EdgeInsets.zero,
            tabs: items,
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
      height: 50,
      child: Tab(
        child: Column(
          children: <Widget>[
            RichText(
              text: TextSpan(
                children: [TextSpan(text: '$count', style: TextStyle(color: AppColors.defaultColor, fontSize: 22))],
              ),
            ),
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
