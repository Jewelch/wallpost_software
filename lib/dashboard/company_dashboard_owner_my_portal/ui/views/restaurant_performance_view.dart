import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/view_contracts/module_performance_view.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/views/performance_view_holder.dart';

import '../../../../_common_widgets/screen_presenter/screen_presenter.dart';
import '../../../../restaurant/restaurant_dashboard/ui/views/screens/restaurant_dashboard_screen.dart';
import '../models/owner_dashboard_filters.dart';
import '../models/performance_value.dart';
import '../presenters/restaurant_performance_presenter.dart';
import 'module_loader.dart';

class RestaurantPerformanceView extends StatefulWidget {
  final OwnerDashboardFilters _filters;

  RestaurantPerformanceView(this._filters);

  @override
  State<RestaurantPerformanceView> createState() => _RestaurantPerformanceViewState();
}

class _RestaurantPerformanceViewState extends State<RestaurantPerformanceView>
    with AutomaticKeepAliveClientMixin<RestaurantPerformanceView>
    implements ModulePerformanceView {
  late final RestaurantPerformancePresenter _presenter;
  final _viewTypeNotifier = ItemNotifier<int>(defaultValue: 0);
  final int viewTypeLoader = 0;
  final int viewTypeError = 1;
  final int viewTypeData = 2;
  Timer? _backgroundSyncTimer;

  @override
  void initState() {
    _presenter = RestaurantPerformancePresenter(this, widget._filters);
    _presenter.loadData();
    super.initState();
  }

  @override
  void dispose() {
    _backgroundSyncTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        ScreenPresenter.present(
          RestaurantDashboardScreen(),
          context,
          slideDirection: SlideDirection.fromBottom,
        );
      },
      child: VisibilityDetector(
        key: Key('restaurant-performance-view'),
        onVisibilityChanged: (visibilityInfo) {
          if (visibilityInfo.visibleFraction == 1.0) _presenter.loadData();
        },
        child: PerformanceViewHolder(
          padding: EdgeInsets.all(8),
          content: Center(
            child: ItemNotifiable<int>(
              notifier: _viewTypeNotifier,
              builder: (context, viewType) {
                if (viewType == viewTypeLoader) {
                  return ModuleLoader();
                } else if (viewType == viewTypeError) {
                  return _errorView();
                } else {
                  return _dataView();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _errorView() {
    return Container(
      child: GestureDetector(
        onTap: () => _presenter.loadData(),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              _presenter.errorMessage,
              textAlign: TextAlign.center,
              style: TextStyles.titleTextStyle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _dataView() {
    return Row(
      children: [
        Expanded(
          child: PerformanceViewHolder(
            content: _tile(_presenter.getTodaysSale()),
            backgroundColor: AppColors.lightGreen,
            showShadow: false,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: PerformanceViewHolder(
            content: _tile(_presenter.getYTDSale()),
            backgroundColor: AppColors.lightYellow,
            showShadow: false,
          ),
        ),
      ],
    );
  }

  Widget _tile(PerformanceValue performanceValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          performanceValue.value,
          style: TextStyles.extraLargeTitleTextStyleBold.copyWith(color: performanceValue.textColor),
        ),
        SizedBox(height: 2),
        Text(
          performanceValue.label,
          style: TextStyles.labelTextStyle.copyWith(color: AppColors.textColorBlack),
        )
      ],
    );
  }

  //MARK: View functions

  @override
  void showLoader() {
    _viewTypeNotifier.notify(viewTypeLoader);
  }

  @override
  void showErrorMessage() {
    _viewTypeNotifier.notify(viewTypeError);
  }

  @override
  void onDidLoadData() {
    _viewTypeNotifier.notify(viewTypeData);
    _startSyncingDataAtRegularIntervals();
  }

  void _startSyncingDataAtRegularIntervals() {
    if (_backgroundSyncTimer == null || _backgroundSyncTimer!.isActive == false) {
      _backgroundSyncTimer = new Timer.periodic(const Duration(seconds: 30), (Timer timer) {
        _presenter.loadData();
      });
    }
  }

  //MARK: AutomaticKeepAliveClientMixin functions to retain data

  @override
  bool get wantKeepAlive => true;
}
