import 'package:flutter/material.dart';

import '../../../../../_common_widgets/app_bars/sliver_app_bar_delegate.dart';
import '../../../../../_common_widgets/filter_views/custom_filter_chip.dart';
import '../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../_shared/constants/app_colors.dart';
import '../../../entities/sales_break_down_wise_options.dart';
import '../../presenters/dashboard_presenter.dart';

class SliverSalesBreakHorizontalList extends StatefulWidget {
  final DashboardPresenter presenter;

  const SliverSalesBreakHorizontalList({Key? key, required this.presenter}) : super(key: key);

  @override
  State<SliverSalesBreakHorizontalList> createState() => _SliverSalesBreakHorizontalListState();
}

class _SliverSalesBreakHorizontalListState extends State<SliverSalesBreakHorizontalList> {
  late DashboardPresenter presenter;

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
                  'Sales Breakdown By:',
                  style: TextStyles.largeTitleTextStyleBold.copyWith(),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 32,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Visibility(
                      visible: presenter.salesBrakdownOptionsWithIndexIsVisible(index),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: CustomFilterChip(
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
                        ),
                      ),
                    );
                  },
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
