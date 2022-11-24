import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/view_contracts/module_performance_view.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/views/performance_view_holder.dart';

import '../models/owner_dashboard_filters.dart';
import '../models/performance_value.dart';
import '../presenters/hr_performance_presenter.dart';
import 'module_loader.dart';

class HRPerformanceView extends StatefulWidget {
  final OwnerDashboardFilters _filters;

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: PerformanceViewHolder(
                  content: _tile(_presenter.getActiveStaff()),
                  backgroundColor: AppColors.lightGreen,
                  showShadow: false,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: PerformanceViewHolder(
                  content: _tile(_presenter.getEmployeeCost()),
                  backgroundColor: AppColors.lightGreen,
                  showShadow: false,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: PerformanceViewHolder(
                  content: _tile(_presenter.getStaffOnLeaveToday()),
                  backgroundColor: AppColors.lightYellow,
                  showShadow: false,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: PerformanceViewHolder(
                  content: _tile(_presenter.getDocumentsExpired()),
                  backgroundColor: AppColors.lightYellow,
                  showShadow: false,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _tile(PerformanceValue performanceValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          performanceValue.value,
          style: TextStyles.largeTitleTextStyleBold.copyWith(color: performanceValue.textColor),
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
  }

  //MARK: AutomaticKeepAliveClientMixin functions to retain data

  @override
  bool get wantKeepAlive => true;
}
