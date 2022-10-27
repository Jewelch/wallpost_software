import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/date_range_selector/date_range_selector.dart';
import 'package:wallpost/dashboard/company_dashboard/ui/views/company_dashboard_app_bar.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/aggregated_sales_data.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_break_down_item.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/presenters/restaurant_dashboard_presenter.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/view_contracts/restaurant_dashboard_view.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/views/restaurant_dashboard_header_card.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/views/restaurant_dashboard_loader.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/views/sales_break_down_card.dart';
import 'package:wallpost/settings/left_menu/left_menu_screen.dart';

import '../../../../_common_widgets/filter_views/dropdown_filter.dart';
import '../../entities/sales_break_down_wise_options.dart';

enum _ScreenStates { loading, error, data }

class RestaurantDashboardScreen extends StatefulWidget {
  @override
  State<RestaurantDashboardScreen> createState() => _State();
}

class _State extends State<RestaurantDashboardScreen> implements RestaurantDashboardView {
  late RestaurantDashboardPresenter _salesPresenter = RestaurantDashboardPresenter(this);

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final salesDataNotifier = ItemNotifier<AggregatedSalesData?>(defaultValue: null);
  final salesBreakDownsNotifier = ItemNotifier<List<SalesBreakDownItem>>(defaultValue: []);
  final screenStateNotifier = ItemNotifier<_ScreenStates>(defaultValue: _ScreenStates.loading);

  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _loadSalesData();
  }

  void _loadSalesData() {
    // _salesPresenter.loadAggregatedSalesData().then((value) {
    //   if (value is AggregatedSalesData) {
    _salesPresenter.loadSalesBreakDown();
    // }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: ItemNotifiable<_ScreenStates>(
        notifier: screenStateNotifier,
        builder: (_, value) => <_ScreenStates, Widget>{
          //$ LOADING STATE
          _ScreenStates.loading: RestaurantDashboardLoader(),
          //! ERROR STATE
          _ScreenStates.error: Column(
            children: [
              SizedBox(height: 10),
              _AppBar(salesPresenter: _salesPresenter),
              SizedBox(height: 10),
              Expanded(
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
          ),
          //* DATA STATE
          _ScreenStates.data: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _AppBar(salesPresenter: _salesPresenter),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 28),
                  child: Row(
                    children: [
                      Spacer(),
                      InkWell(
                        onTap: showDateRangeSelector,
                        child: Text(
                          _salesPresenter.dateFilters.selectedRangeOption.toReadableString(),
                          style: TextStyles.largeTitleTextStyleBold.copyWith(color: AppColors.defaultColor),
                        ),
                      ),
                      SizedBox(width: 8),
                      SvgPicture.asset(
                        'assets/icons/arrow_down_icon.svg',
                        color: AppColors.defaultColor,
                        height: 14,
                      ),
                    ],
                  ),
                ),
                ItemNotifiable<AggregatedSalesData?>(
                  notifier: salesDataNotifier,
                  builder: (context, value) => RestaurantDashboardHeaderCard(value),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sales Breakdown', style: TextStyles.largeTitleTextStyleBold),
                      DropdownFilter(
                        items: SalesBreakDownWiseOptions.values.map((strategy) => strategy.toReadableString()).toList(),
                        selectedValue: _salesPresenter.selectedBreakDownWise.toReadableString(),
                        textStyle: TextStyles.largeTitleTextStyleBold.copyWith(color: AppColors.defaultColor),
                        backgroundColor: Colors.transparent,
                        dropdownColor: AppColors.filtersBackgroundColor,
                        dropdownArrowColor: AppColors.defaultColor,
                        onDidSelectedItemAtIndex: _salesPresenter.selectSalesBreakDownWiseAtIndex,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                ItemNotifiable<List<SalesBreakDownItem>>(
                  notifier: salesBreakDownsNotifier,
                  builder: (context, salesBreakDowns) => salesBreakDowns.isEmpty
                      ? Padding(
                          padding: EdgeInsets.only(top: 120),
                          child: Text(
                            "There is no sales breakdowns with these filters",
                            textAlign: TextAlign.center,
                            style: TextStyles.titleTextStyle,
                          ),
                        )
                      : SalesBreakDownCard(
                          salesBreakDowns
                            ..sort(
                              (a, b) => a.totalSales == b.totalSales
                                  ? 0
                                  : a.totalSales > b.totalSales
                                      ? -1
                                      : 1,
                            ),
                        ),
                ),
              ],
            ),
          ),
        }[value]!,
      ),
    );
  }

  //MARK: View functions

  @override
  void showLoader() {
    screenStateNotifier.notify(_ScreenStates.loading);
  }

  @override
  void showErrorMessage(String errorMessage) {
    this.errorMessage = errorMessage;
    screenStateNotifier.notify(_ScreenStates.error);
  }

  void showDateRangeSelector() async {
    var dateRange = await DateRangeSelector.show(
      context,
      initialDateRangeFilter: _salesPresenter.dateFilters,
      onDateRangeFilterSelected: (dateFilters) => _salesPresenter.dateFilters = dateFilters,
    );
    if (dateRange != null) {
      _salesPresenter.dateFilters = dateRange;
      _loadSalesData();
    }
  }

  @override
  void updateSalesData(AggregatedSalesData salesData) => salesDataNotifier.notify(salesData);

  @override
  void showSalesBreakDowns(List<SalesBreakDownItem> salesBreakDowns) {
    salesBreakDownsNotifier.notify(salesBreakDowns);
    screenStateNotifier.notify(_ScreenStates.data);
  }

  @override
  void onDidChangeSalesBreakDownWise() => setState(_salesPresenter.loadSalesBreakDown);
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    Key? key,
    required this.salesPresenter,
  }) : super(key: key);

  final RestaurantDashboardPresenter salesPresenter;

  @override
  Widget build(BuildContext context) {
    return CompanyDashboardAppBar(
      companyName: salesPresenter.getSelectedCompanyName(),
      profileImageUrl: salesPresenter.getProfileImageUrl(),
      onLeftMenuButtonPress: () => LeftMenuScreen.show(context),
      onAddButtonPress: () {},
      onTitlePress: () => Navigator.pop(context),
    );
  }
}
