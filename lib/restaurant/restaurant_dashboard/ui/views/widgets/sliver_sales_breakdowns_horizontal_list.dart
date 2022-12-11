import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/filter_views/custom_filter_chip.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_break_down_wise_options.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/presenters/restaurant_dashboard_presenter.dart';

import '../../../../../_shared/constants/app_colors.dart';

class SliverSalesBreakHorizontalList extends StatefulWidget {
  final RestaurantDashboardPresenter presenter;

  const SliverSalesBreakHorizontalList({Key? key, required this.presenter}) : super(key: key);

  @override
  State<SliverSalesBreakHorizontalList> createState() => _SliverSalesBreakHorizontalListState();
}

class _SliverSalesBreakHorizontalListState extends State<SliverSalesBreakHorizontalList> {
  late RestaurantDashboardPresenter presenter;

  @override
  void initState() {
    presenter = widget.presenter;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
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
                  style: TextStyles.largeTitleTextStyleBold.copyWith(),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 32,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return CustomFilterChip(
                      backgroundColor: presenter.getSalesBreakdownFilterBackgroundColor(index),
                      borderColor: Colors.transparent,
                      title: Text(
                        presenter.getSalesBreakDownFilterName(index),
                        style: TextStyle(
                          color: presenter.getSalesBreakdownFilterTextColor(index),
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () => setState(() => presenter.selectSalesBreakDownWiseAtIndex(index)),
                    );
                  },
                  separatorBuilder: ((_, __) => SizedBox(width: 16)),
                  itemCount: SalesBreakDownWiseOptions.values.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  SliverAppBarDelegate({
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
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
