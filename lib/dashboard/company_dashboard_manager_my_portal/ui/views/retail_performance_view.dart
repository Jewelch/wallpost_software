import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/ui/view_contracts/module_performance_view.dart';

import '../models/manager_dashboard_filters.dart';
import '../models/performance_value.dart';
import '../presenters/retail_performance_presenter.dart';
import 'module_loader.dart';

class RetailPerformanceView extends StatefulWidget {
  final ManagerDashboardFilters _filters;

  RetailPerformanceView(this._filters);

  @override
  State<RetailPerformanceView> createState() => RetailPerformanceViewState();
}

class RetailPerformanceViewState extends State<RetailPerformanceView>
    with AutomaticKeepAliveClientMixin<RetailPerformanceView>
    implements ModulePerformanceView {
  late final RetailPerformancePresenter _presenter;
  final _viewTypeNotifier = ItemNotifier<int>(defaultValue: 0);
  final int viewTypeLoader = 0;
  final int viewTypeError = 1;
  final int viewTypeData = 2;

  @override
  void initState() {
    _presenter = RetailPerformancePresenter(this, widget._filters);
    _presenter.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return VisibilityDetector(
      key: Key('retail-performance-view'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction == 1.0) _presenter.loadData();
      },
      child: Center(
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
              style: TextStyles.titleTextStyle.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dataView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: _tile(_presenter.getTodaysSale())),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 50),
          child: VerticalDivider(color: AppColors.screenBackgroundColor.withOpacity(.6)),
        ),
        Expanded(child: _tile(_presenter.getYTDSale())),
      ],
    );
  }

  Widget _tile(PerformanceValue performanceValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          performanceValue.value,
          style: TextStyles.headerCardMainValueTextStyle.copyWith(
            color: performanceValue.textColor,
          ),
        ),
        SizedBox(height: 4),
        Text(
          performanceValue.label,
          textAlign: TextAlign.center,
          style: TextStyles.headerCardSubLabelTextStyle,
        ),
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
  }

  //MARK: AutomaticKeepAliveClientMixin functions to retain data

  @override
  bool get wantKeepAlive => true;
}
