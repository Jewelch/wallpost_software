import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:wallpost/_common_widgets/filter_views/ytd_filter_modal_sheet.dart';
import 'package:wallpost/crm/dashboard/ui/view_contracts/crm_dashboard_view.dart';

import '../../../../../_common_widgets/app_bars/sliver_app_bar_delegate.dart';
import '../../../../../_common_widgets/filter_views/custom_filter_chip.dart';
import '../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../_shared/constants/app_colors.dart';
import '../../presenters/crm_dashboard_presenter.dart';
import '../loader/crm_dashboard_loader.dart';
import '../widgets/crm_dashboard_app_bar.dart';
import '../widgets/crm_dashboard_error_view.dart';
import '../widgets/crm_dashboard_filters_bar.dart';
import '../widgets/crm_dashboard_header_card.dart';
import '../widgets/crm_dashboard_performance_list.dart';

enum _ScreenStates { loading, error, data }

class CrmDashboardScreen extends StatefulWidget {
  @override
  State<CrmDashboardScreen> createState() => _State();
}

class _State extends State<CrmDashboardScreen> implements CrmDashboardView {
  late CrmDashboardPresenter _presenter = CrmDashboardPresenter(this);
  final screenStateNotifier = ItemNotifier<_ScreenStates>(defaultValue: _ScreenStates.loading);
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _presenter.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        _presenter.loadData();
        return Future.value(null);
      },
      child: Scaffold(
        backgroundColor: AppColors.screenBackgroundColor,
        appBar: CrmDashboardAppBar(_presenter.getCompanyName()),
        body: ItemNotifiable<_ScreenStates>(
          notifier: screenStateNotifier,
          builder: (_, currentState) {
            switch (currentState) {
              //$ LOADING STATE
              case _ScreenStates.loading:
                return CrmDashboardLoader();

              //! ERROR STATE
              case _ScreenStates.error:
                return CrmDashboardErrorView(
                  errorMessage: errorMessage,
                  onRetry: () => _presenter.loadData(),
                );

              //* DATA STATE
              case _ScreenStates.data:
                return _dataView();
            }
          },
        ),
      ),
    );
  }

  Widget _dataView() {
    return SafeArea(
      child: Container(
        color: AppColors.screenBackgroundColor2,
        child: CustomScrollView(
          slivers: [
            MultiSliver(
              children: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverAppBarDelegate(
                    minHeight: 52,
                    maxHeight: 52,
                    child: CrmDashboardFiltersBar(_presenter),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  sliver: SliverToBoxAdapter(child: CrmDashboardHeaderCard(_presenter)),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 24)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Performance:',
                      style: TextStyles.largeTitleTextStyleBold.copyWith(),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 4)),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: SizedBox(
                      height: 32,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return CustomFilterChip(
                            backgroundColor: _presenter.getPerformanceFilterBackgroundColor(index),
                            borderColor: Colors.transparent,
                            title: Text(
                              _presenter.getPerformanceFilterNameAtIndex(index),
                              style: TextStyle(
                                color: _presenter.getPerformanceFilterTextColor(index),
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onPressed: () => _presenter.selectPerformanceTypeAtIndex(index),
                          );
                        },
                        separatorBuilder: ((_, __) => SizedBox(width: 16)),
                        itemCount: 2, //SalesBreakDownWiseOptions.values.length,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 8)),
                SliverToBoxAdapter(
                  child: CrmDashboardPerformanceList(_presenter),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 16)),
              ],
            )
          ],
        ),
      ),
    );
  }

  //MARK: View functions

  @override
  void showLoader() {
    screenStateNotifier.notify(_ScreenStates.loading);
  }

  @override
  void onDidFailToLoadData(String errorMessage) {
    this.errorMessage = errorMessage;
    screenStateNotifier.notify(_ScreenStates.error);
  }

  @override
  void onDidLoadData() {
    screenStateNotifier.notify(_ScreenStates.data);
  }

  @override
  void showYTDFilters(int initialMonth, int initialYear) {
    YTDFilterModalSheet.show(
      context,
      initialMonth: initialMonth,
      initialYear: initialYear,
      onDidSelectFilter: (selectedMonth, selectedYear) {
        _presenter.setYTDFilter(month: selectedMonth, year: selectedYear);
      },
    );
  }

  @override
  void onDidSetPerformanceTypeFilter() {
    setState(() {});
  }
}
