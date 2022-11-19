import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';

import '../../../../_shared/constants/app_colors.dart';

class RestaurantDashBoardSliverSubHeader extends StatelessWidget {
  final Widget child;

  const RestaurantDashBoardSliverSubHeader({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
          minHeight: 56 + 32 + 16,
          maxHeight: 56 + 32 + 16,
          child: ColoredBox(
            color: AppColors.screenBackgroundColor2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Sales Breakdown',
                    style: TextStyles.largeTitleTextStyleBold.copyWith(
                      fontFamily: "SF-Pro-Display",
                    ),
                  ),
                ),
                SizedBox(height: 16),
                child,
              ],
            ),
          )),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
