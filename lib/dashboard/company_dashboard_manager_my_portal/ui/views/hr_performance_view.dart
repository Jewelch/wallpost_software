import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/ui/view_contracts/module_performance_view.dart';

import '../models/manager_dashboard_filters.dart';
import '../models/performance_value.dart';
import '../presenters/hr_performance_presenter.dart';
import 'module_loader.dart';

class HRPerformanceView extends StatefulWidget {
  final ManagerDashboardFilters _filters;

  HRPerformanceView(this._filters);

  @override
  State<HRPerformanceView> createState() => _HRPerformanceViewState();
}

class _HRPerformanceViewState extends State<HRPerformanceView>
    with AutomaticKeepAliveClientMixin<HRPerformanceView>
    implements ModulePerformanceView {
  late final HRPerformancePresenter _presenter;
  final _viewTypeNotifier = ItemNotifier<int>(defaultValue: 0);
  final int viewTypeLoader = 0;
  final int viewTypeError = 1;
  final int viewTypeData = 2;

  @override
  void initState() {
    _presenter = HRPerformancePresenter(this, widget._filters);
    _presenter.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return VisibilityDetector(
      key: Key('hr-performance-view'),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _presenter.getActiveStaff().value,
              style: TextStyles.headerCardMainValueTextStyle.copyWith(
                color: _presenter.getActiveStaff().textColor,
              ),
            ),
            SizedBox(height: 4),
            Text(
              _presenter.getActiveStaff().label,
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
            Expanded(child: _tile(_presenter.getStaffOnLeaveToday())),
            SizedBox(width: 12),
            Expanded(child: _tile(_presenter.getRecruitment())),
            SizedBox(width: 12),
            Expanded(child: _tile(_presenter.getDocumentsExpired())),
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
  }

  //MARK: AutomaticKeepAliveClientMixin functions to retain data

  @override
  bool get wantKeepAlive => true;
}
