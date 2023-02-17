import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:notifiable/notifiable.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../../../../_common_widgets/app_bars/sliver_app_bar_delegate.dart';
import '../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../_shared/constants/app_colors.dart';
import '../../../../common_widgets/sales_break_down_loader.dart';
import '../../presenters/restaurant_dashboard_presenter.dart';
import '../../view_contracts/restaurant_dashboard_view.dart';
import '../loader/restaurant_dashboard_loader.dart';
import '../widgets/report_floating_action_button.dart';
import '../widgets/restaurant_dashboard_appbar.dart';
import '../widgets/restaurant_dashboard_error_view.dart';
import '../widgets/restaurant_dashboard_header_card.dart';
import '../widgets/restaurant_dashboard_sales_break_down_card.dart';
import '../widgets/restaurant_filters.dart';
import '../widgets/sliver_sales_breakdowns_horizontal_list.dart';

enum _ScreenStates { loading, error, data }

enum _SalesBreakDownStates { loading, error, data, noData }

class RestaurantDashboardScreen extends StatefulWidget {
  @override
  State<RestaurantDashboardScreen> createState() => _State();
}

class _State extends State<RestaurantDashboardScreen> implements RestaurantDashboardView {
  late RestaurantDashboardPresenter _presenter = RestaurantDashboardPresenter(this);
  final salesDataNotifier = Notifier();
  final salesBreakDownsNotifier = ItemNotifier<_SalesBreakDownStates>(defaultValue: _SalesBreakDownStates.loading);
  final screenStateNotifier = ItemNotifier<_ScreenStates>(defaultValue: _ScreenStates.loading);
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _loadSalesData();
  }

  void _loadSalesData() =>
      _presenter.loadAggregatedSalesData().then((_) => _presenter.loadSalesBreakDown(singleTask: false));

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => _loadSalesData(),
      child: Scaffold(
        backgroundColor: AppColors.screenBackgroundColor,
        body: ItemNotifiable<_ScreenStates>(
          notifier: screenStateNotifier,
          builder: (_, currentState) {
            switch (currentState) {
              //$ LOADING STATE
              case _ScreenStates.loading:
                return RestaurantDashboardLoader();

              //! ERROR STATE
              case _ScreenStates.error:
                return RestaurantDashboardErrorView(
                  errorMessage: errorMessage,
                  onRetry: _loadSalesData,
                );

              //* DATA STATE
              case _ScreenStates.data:
                return _dataView();
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: ReportsFloatingActionButton(presenter: _presenter),
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
                    minHeight: 56 + 32 + 16,
                    maxHeight: 56 + 32 + 16,
                    child: RestaurantDashboardAppBar(_presenter),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  sliver: Notifiable(
                    notifier: salesDataNotifier,
                    builder: (context) => SliverToBoxAdapter(child: RestaurantDashboardHeaderCard(_presenter)),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 16),
                ),
                SliverSalesBreakHorizontalList(
                  presenter: _presenter,
                ),
                _salesBreakdownViews(),
                SliverToBoxAdapter(child: SizedBox(height: 16)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _salesBreakdownViews() {
    return ItemNotifiable<_SalesBreakDownStates>(
      notifier: salesBreakDownsNotifier,
      builder: (_, currentState) {
        switch (currentState) {
          //* LOADING STATE
          case _SalesBreakDownStates.loading:
            return SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: SalesBreakDownLoader(count: 2),
              ),
            );

          // //! ERROR STATE
          case _SalesBreakDownStates.error:
            return MultiSliver(
              children: [
                SliverToBoxAdapter(
                  child: Container(
                    child: TextButton(
                      child: Text(
                        errorMessage,
                        textAlign: TextAlign.center,
                        style: TextStyles.titleTextStyle,
                      ),
                      onPressed: _loadSalesData,
                    ),
                  ),
                ),
              ],
            );

          //* DATA STATE
          case _SalesBreakDownStates.data:
            return SliverToBoxAdapter(child: SalesBreakDownCard(_presenter));

          //* NO DATA STATE
          default:
            return SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 100),
                child: Text(
                  "There are no sales breakdown for\nthe selected filters",
                  textAlign: TextAlign.center,
                  style: TextStyles.titleTextStyle,
                ),
              ),
            );
        }
      },
    );
  }

  //MARK: View functions

  @override
  void showLoader() => screenStateNotifier.notify(_ScreenStates.loading);

  @override
  void showErrorMessage(String errorMessage) {
    this.errorMessage = errorMessage;
    screenStateNotifier.notify(_ScreenStates.error);
  }

  void showDateRangeSelector() async {
    var dateRange = await RestaurantFilters.show(
      context,
      initialDateRangeFilter: _presenter.dateFilters,
    );
    if (dateRange != null) {
      _presenter.dateFilters = dateRange;
      _loadSalesData();
    }
  }

  @override
  void updateSalesData() => salesDataNotifier.notify();

  @override
  void showNoSalesBreakdownMessage() {
    screenStateNotifier.notify(_ScreenStates.data);
    salesBreakDownsNotifier.notify(_SalesBreakDownStates.noData);
  }

  @override
  void showSalesBreakDowns() {
    screenStateNotifier.notify(_ScreenStates.data);
    salesBreakDownsNotifier.notify(_SalesBreakDownStates.data);
  }

  @override
  void onDidChangeSalesBreakDownWise() => _presenter.loadSalesBreakDown(singleTask: true);

  @override
  void showLoadingForSalesBreakDowns() => salesBreakDownsNotifier.notify(_SalesBreakDownStates.loading);

  @override
  void showRestaurantDashboardFilter() async {
    var newDateFilter = await RestaurantFilters.show(
      context,
      initialDateRangeFilter: _presenter.dateFilters.copy(),
    );
    if (newDateFilter != null) {
      _presenter.dateFilters = newDateFilter;
      _loadSalesData();
    }
  }
}
