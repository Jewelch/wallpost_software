import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:notifiable/notifiable.dart';
import 'package:wallpost/_common_widgets/filter_views/custom_filter_chip.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/date_range_selector/date_range_selector.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_break_down_wise_options.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/presenters/restaurant_dashboard_presenter.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/view_contracts/restaurant_dashboard_view.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/views/restaurant_dashboard_header_card.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/views/restaurant_dashboard_loader.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/views/sales_break_down_card.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/views/sales_break_down_loader.dart';

import 'restaurant_dashboard_appbar.dart';

enum _ScreenStates { loading, error, data }

enum _SalesBreakDownStates { loading, error, data, noData }

class RestaurantDashboardScreen extends StatefulWidget {
  @override
  State<RestaurantDashboardScreen> createState() => _State();
}

class _State extends State<RestaurantDashboardScreen> implements RestaurantDashboardView {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late RestaurantDashboardPresenter _salesPresenter = RestaurantDashboardPresenter(this);
  final salesDataNotifier = Notifier();
  final salesBreakDownsNotifier = ItemNotifier<_SalesBreakDownStates>(defaultValue: _SalesBreakDownStates.loading);
  final screenStateNotifier = ItemNotifier<_ScreenStates>(defaultValue: _ScreenStates.loading);
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _loadSalesData();
  }

  void _loadSalesData() => _salesPresenter.loadAggregatedSalesData().then(
        (_) => _salesPresenter.loadSalesBreakDown(singleTask: false),
      );

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => _loadSalesData(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.screenBackgroundColor2,
        body: ItemNotifiable<_ScreenStates>(
          notifier: screenStateNotifier,
          builder: (_, currentState) {
            switch (currentState) {
              //$ LOADING STATE
              case _ScreenStates.loading:
                return RestaurantDashboardLoader();

              //! ERROR STATE
              case _ScreenStates.error:
                return Column(
                  children: [
                    SizedBox(height: 10),
                    RestaurantDashboardAppBar(salesPresenter: _salesPresenter),
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
                );

              //* DATA STATE
              case _ScreenStates.data:
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      RestaurantDashboardAppBar(salesPresenter: _salesPresenter),
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
                      Notifiable(
                        notifier: salesDataNotifier,
                        builder: (context) => RestaurantDashboardHeaderCard(_salesPresenter),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            //fixed
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            //WRONG COLOR & Font // Done
                            child: Text('Sales Breakdown', style: TextStyles.largeTitleTextStyleBold),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            //fixed
                            height: 32,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              //fixed
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              itemBuilder: (context, index) {
                                return CustomFilterChip(
                                    //Move this to presenter // Done
                                    backgroundColor: _salesPresenter.getSalesBreakdownChipColor(index),
                                    borderColor: Colors.transparent,
                                    title: Text(
                                      //Move this to presenter // Done
                                      _salesPresenter.getSalesBreakDownWiseOptions(index),
                                      style: TextStyle(
                                          //Move this to presenter // Done
                                          //WRONG COLOR & Font // done
                                          color: _salesPresenter.getSalesBreakdownTextColor(index),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "SF-Pro-Display"),
                                    ),
                                    onPressed: () => setState(() => _salesPresenter.selectSalesBreakDownWiseAtIndex(index)));
                              },
                              //fixed
                              separatorBuilder: ((_, __) => SizedBox(width: 16)),
                              //fixed
                              itemCount: SalesBreakDownWiseOptions.values.length,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      ItemNotifiable<_SalesBreakDownStates>(
                          notifier: salesBreakDownsNotifier,
                          builder: (_, currentState) {
                            switch (currentState) {

                              //* LOADING STATE
                              case _SalesBreakDownStates.loading:
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                  child: SalesBreakDownLoader(cornerRadius: 10, height: 350, width: double.infinity),
                                );

                              //! ERROR STATE
                              case _SalesBreakDownStates.error:
                                return Column(
                                  children: [
                                    Container(
                                      child: TextButton(
                                        child: Text(
                                          errorMessage,
                                          textAlign: TextAlign.center,
                                          style: TextStyles.titleTextStyle,
                                        ),
                                        onPressed: _loadSalesData,
                                      ),
                                    ),
                                  ],
                                );

                              //* DATA STATE
                              case _SalesBreakDownStates.data:
                                return SalesBreakDownCard(_salesPresenter);

                              //* NO DATA STATE
                              default:
                                return Padding(
                                  padding: EdgeInsets.only(top: 120),
                                  child: Text(
                                    "There is no sales breakdown with these filters",
                                    textAlign: TextAlign.center,
                                    //WRONG COLOR & Font // Done

                                    style: TextStyles.titleTextStyle,
                                  ),
                                );
                            }
                          }),

                      //fixed
                      SizedBox(height: 16),
                    ],
                  ),
                );
            }
          },
        ),
      ),
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
  void updateSalesData() => salesDataNotifier.notify();

  @override
  void showSalesBreakDowns() {
    screenStateNotifier.notify(_ScreenStates.data);
    _salesPresenter.breakdownsIsEmpty()
        ? salesBreakDownsNotifier.notify(_SalesBreakDownStates.noData)
        : salesBreakDownsNotifier.notify(_SalesBreakDownStates.data);
  }

  @override
  void onDidChangeSalesBreakDownWise() => _salesPresenter.loadSalesBreakDown(singleTask: true);

  @override
  void showLloadingForSalesBreakDowns() => salesBreakDownsNotifier.notify(_SalesBreakDownStates.loading);
}
