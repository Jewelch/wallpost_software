import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/view_contracts/module_performance_view.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/views/module_box_view_holder.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/views/performance_view_holder_module_new.dart';
import '../models/owner_dashboard_filters.dart';
import '../models/performance_value.dart';
import '../presenters/crm_performance_presenter.dart';
import 'module_loader.dart';

class CRMPerformanceView extends StatefulWidget {
  final OwnerDashboardFilters _filters;

  CRMPerformanceView(this._filters);

  @override
  State<CRMPerformanceView> createState() => _CRMPerformanceViewState();
}

class _CRMPerformanceViewState extends State<CRMPerformanceView>
    with AutomaticKeepAliveClientMixin<CRMPerformanceView>
    implements ModulePerformanceView {
  late final CRMPerformancePresenter _presenter;
  final _viewTypeNotifier = ItemNotifier<int>(defaultValue: 0);
  final int viewTypeLoader = 0;
  final int viewTypeError = 1;
  final int viewTypeData = 2;

  @override
  void initState() {
    _presenter = CRMPerformancePresenter(this, widget._filters);
    _presenter.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return VisibilityDetector(
      key: Key('crm-performance-view'),
      onVisibilityChanged: (visibilityInfo) {
        print(visibilityInfo.visibleFraction);
        if (visibilityInfo.visibleFraction == 1.0) _presenter.loadData();
      },
      child: PerformanceViewHolderNew(
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

  // saeed edited  - added new view holder
  Widget _dataView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
                child: ModuleBoxViewHolder(
              content: _tile(_presenter.getActualRevenue()),
              backgroundColor: Color(0xFFE8FCF3),
            )),
            SizedBox(width: 8),
            Expanded(
                child: ModuleBoxViewHolder(
                    content: _tile(_presenter.getTargetAchieved()), backgroundColor: Color(0xFFE8FCF3))),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                child: ModuleBoxViewHolder(
              content: _tile(_presenter.getInPipeline()),
              backgroundColor: Color(0xFFF0F5FA),
            )),
            SizedBox(width: 8),
            Expanded(
                child: ModuleBoxViewHolder(
              content: _tile(_presenter.getLeadConverted()),
              backgroundColor: Color(0xFFFCE9E8),
            )),
          ],
        )
      ],
    );
  }

  // Widget _dataView() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Row(
  //         children: [
  //           SizedBox(width: 12),
  //           Expanded(child: _tile(_presenter.getActualRevenue())),
  //           SizedBox(width: 12),
  //           Expanded(child: _tile(_presenter.getTargetAchieved())),
  //           SizedBox(width: 12),
  //         ],
  //       ),
  //       SizedBox(height: 12),
  //       Row(
  //         children: [
  //           SizedBox(width: 40),
  //           Expanded(child: Divider()),
  //           SizedBox(width: 40),
  //           Expanded(child: Divider()),
  //           SizedBox(width: 40),
  //         ],
  //       ),
  //       SizedBox(height: 12),
  //       Row(
  //         children: [
  //           SizedBox(width: 12),
  //           Expanded(child: _tile(_presenter.getInPipeline())),
  //           SizedBox(width: 12),
  //           Expanded(child: _tile(_presenter.getLeadConverted())),
  //           SizedBox(width: 12),
  //         ],
  //       )
  //     ],
  //   );
  // }
  // saeed edited - Text alignment to start

  Widget _tile(PerformanceValue performanceValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          performanceValue.value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
