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
import 'package:wallpost/restaurant/restaurant_dashboard/ui/views/sales_break_down_card.dart';

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

  _State() {
    _salesPresenter = RestaurantDashboardPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CompanyDashboardAppBar(
              companyName: "companyName",
              profileImageUrl: " _presenter.getProfileImageUrl()",
              onLeftMenuButtonPress: () => "LeftMenuScreen.show(context)",
              onAddButtonPress: () {},
              onTitlePress: () => Navigator.pop(context),
            ),
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
              builder: (context, value) => value != null ? RestaurantDashboardHeaderCard(value) : SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text('Sales Breakdown', style: TextStyles.titleTextStyleBold),
                  SizedBox(width: 15),
                  Flexible(
                    child: DropdownFilter(
                      items: SalesBreakDownWiseOptions.values.map((strategy) => strategy.toReadableString()).toList(),
                      selectedValue: _salesPresenter.selectedBreakDownWise.toReadableString(),
                      textStyle: TextStyles.largeTitleTextStyleBold.copyWith(color: AppColors.defaultColor),
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
              builder: (context, value) => SalesBreakDownCard(value),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void showLoader() {}

  @override
  void showSalesData(AggregatedSalesData salesData) => _salesDataNotifier.notify(salesData);

  void showDateRangeSelector() async {
    await DateRangeSelector.show(
      context,
      onDateRangeFilterSelected: (dateFilters) => _salesPresenter.dateFilters = dateFilters,
      initialDateRangeFilter: _salesPresenter.dateFilters,
    );
    setState(() {});
  }

  @override
  void showErrorMessage(String errorMessage) {}

  @override
  void showSalesBreakDowns(List<SalesBreakDownItem> salesBreakDowns) {
    _salesBreakDownsNotifier.notify(salesBreakDowns);
  }

  @override
  void onDidSelectSalesBreakdownFilteringStrategy() => setState(() {
        _salesPresenter.loadSalesBreakDown();
      });
}
