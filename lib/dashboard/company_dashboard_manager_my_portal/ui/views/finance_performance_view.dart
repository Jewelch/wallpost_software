import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/ui/view_contracts/module_performance_view.dart';

import '../models/manager_dashboard_filters.dart';
import '../models/performance_value.dart';
import '../presenters/finance_performance_presenter.dart';
import 'module_loader.dart';

class FinancePerformanceView extends StatefulWidget {
  final ManagerDashboardFilters _filters;

  FinancePerformanceView(this._filters);

  @override
  State<FinancePerformanceView> createState() => _FinancePerformanceViewState();
}

class _FinancePerformanceViewState extends State<FinancePerformanceView>
    with AutomaticKeepAliveClientMixin<FinancePerformanceView>
    implements ModulePerformanceView {
  late final FinancePerformancePresenter _presenter;
  final _viewTypeNotifier = ItemNotifier<int>(defaultValue: 0);
  final int viewTypeLoader = 0;
  final int viewTypeError = 1;
  final int viewTypeData = 2;
  Timer? _backgroundSyncTimer;

  @override
  void initState() {
    _presenter = FinancePerformancePresenter(this, widget._filters);
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
    return VisibilityDetector(
      key: Key('finance-performance-view'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction == 1.0) _presenter.loadData();
      },
      child: Container(
        padding: EdgeInsets.all(8),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Financials ", style: TextStyles.headerCardHeadingTextStyle),
            _presenter.shouldShowDetailDisclosureIndicator()
                ? Container(
                    height: 12,
                    width: 12,
                    child: SvgPicture.asset(
                      'assets/icons/arrow_forward.svg',
                      width: 12,
                      height: 12,
                      color: AppColors.defaultColor,
                    ),
                  )
                : Container(),
          ],
        ),
        SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _presenter.getProfitLoss().value,
              style: TextStyles.headerCardMainValueTextStyle.copyWith(
                color: _presenter.getProfitLoss().textColor,
              ),
            ),
            Text(
              _presenter.getProfitLoss().label,
              textAlign: TextAlign.center,
              style: TextStyles.headerCardSubLabelTextStyle,
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: Divider(color: AppColors.defaultColorDarkContrastColor)),
            SizedBox(width: 12),
            Expanded(child: Divider(color: AppColors.defaultColorDarkContrastColor)),
            SizedBox(width: 12),
            Expanded(child: Divider(color: AppColors.defaultColorDarkContrastColor)),
          ],
        ),
        Row(
          children: [
            Expanded(child: _tile(_presenter.getAvailableFunds())),
            SizedBox(width: 12),
            Expanded(child: _tile(_presenter.getOverdueReceivables())),
            SizedBox(width: 12),
            Expanded(child: _tile(_presenter.getOverduePayables())),
          ],
        ),
      ],
    );
  }

  Widget _tile(PerformanceValue performanceValue) {
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(performanceValue.value,
              style: TextStyles.headerCardSubValueTextStyle.copyWith(color: performanceValue.textColor)),
        ),
        SizedBox(height: 2),
        Text(
          performanceValue.label,
          style: TextStyles.headerCardSubLabelTextStyle,
          textAlign: TextAlign.center,
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
