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

class RestaurantDashboardScreen extends StatefulWidget {
  @override
  State<RestaurantDashboardScreen> createState() => _State();
}

class _State extends State<RestaurantDashboardScreen> implements RestaurantDashboardView {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _salesDataNotifier = ItemNotifier<AggregatedSalesData?>(defaultValue: null);
  final _salesBreakDownsNotifier = ItemNotifier<List<SalesBreakDownItem>>(defaultValue: []);
  late RestaurantDashboardPresenter _salesPresenter;
  final ItemNotifier<int> _viewTypeNotifier = ItemNotifier(defaultValue: LOADER_VIEW);
  static const LOADER_VIEW = 1;
  static const ERROR_VIEW = 2;
  static const DATA_VIEW = 3;
  var _errorMessage = "";
  AggregatedSalesData? _aggregatedSalesData;

  void _loadSalesData() {
    _salesPresenter.loadAggregatedSalesData().then((value) {
      if (value is AggregatedSalesData) {
    _salesPresenter.loadSalesBreakDown();
    }
    });
  }

  _State() {
    _salesPresenter = RestaurantDashboardPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _loadSalesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ItemNotifiable(
        notifier: _viewTypeNotifier,
        builder: (context, value) {
          if (value == LOADER_VIEW) return RestaurantDashboardLoader();
          if (value == ERROR_VIEW) return _errorAndRetryView();
          if (value == DATA_VIEW) return salesDataView();
          return Container();
        },
      ),
    );
  }

  //MARK: Functions to build the error and retry view

  Widget _errorAndRetryView() {
    return Column(
      children: [
        SizedBox(height: 10),
        _companyAppbar(),
        SizedBox(height: 10),
        Expanded(
          child: Container(
            child: TextButton(
              child: Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: TextStyles.titleTextStyle,
              ),
              onPressed: () => _loadSalesData(),
            ),
          ),
        ),
      ],
    );
  }

  //MARK: Functions to build the sales data view

  Widget salesDataView() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _companyAppbar(),
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
            notifier: _salesDataNotifier,
            builder: (context, value) => RestaurantDashboardHeaderCard(_aggregatedSalesData),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Text('Sales Breakdown', style: TextStyles.titleTextStyleBold),
                ),
                Expanded(
                  child: SizedBox(),
                  flex: 1,
                ),
                Expanded(
                  flex: 4,
                  child: DropdownFilter(
                    items: SalesBreakDownWiseOptions.values.map((strategy) => strategy.toReadableString()).toList(),
                    selectedValue: _salesPresenter.selectedBreakDownWise.toReadableString(),
                    textStyle: TextStyles.titleTextStyleBold.copyWith(color: AppColors.defaultColor),
                    backgroundColor: Colors.transparent,
                    dropdownColor: AppColors.filtersBackgroundColor,
                    dropdownArrowColor: AppColors.defaultColor,
                    onDidSelectedItemAtIndex: _salesPresenter.selectSalesBreakDownWiseAtIndex,
                  ),
                ),
              ],
            ),
          ),
          ItemNotifiable<List<SalesBreakDownItem>>(
            notifier: _salesBreakDownsNotifier,
            builder: (context, salesBreakDowns) => SalesBreakDownCard(salesBreakDowns..sort((a, b) => a.totalSales > b.totalSales ? 0 : 1)),
          ),
        ],
      ),
    );
  }

  Widget _companyAppbar() {
    return CompanyDashboardAppBar(
      companyName: _salesPresenter.getSelectedCompanyName(),
      profileImageUrl: _salesPresenter.getProfileImageUrl(),
      onLeftMenuButtonPress: () => LeftMenuScreen.show(context),
      onAddButtonPress: () {},
      onTitlePress: () => Navigator.pop(context),
    );
  }

  //MARK: View functions

  @override
  void showLoader() {
    _viewTypeNotifier.notify(LOADER_VIEW);
  }

  @override
  void showErrorMessage(String errorMessage) {
    _errorMessage = errorMessage;
    _viewTypeNotifier.notify(ERROR_VIEW);
  }

  void showDateRangeSelector() async {
    await DateRangeSelector.show(
      context,
      initialDateRangeFilter: _salesPresenter.dateFilters,
      onDateRangeFilterSelected: (dateFilters) => _salesPresenter.dateFilters = dateFilters,
    );
    _loadSalesData();
  }

  @override
  void updateSalesData(AggregatedSalesData salesData) {
    _aggregatedSalesData = salesData;
  }

  @override
  void showSalesBreakDowns(List<SalesBreakDownItem> salesBreakDowns) {
    _salesBreakDownsNotifier.notify(salesBreakDowns);
    _viewTypeNotifier.notify(DATA_VIEW);
  }

  @override
  void onDidSelectSalesBreakdownFilteringStrategy() => setState(() {
        _salesPresenter.loadSalesBreakDown();
      });
}
