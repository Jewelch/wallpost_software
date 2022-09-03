import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/banners/bottom_banner.dart';
import 'package:wallpost/_common_widgets/custom_shapes/curve_bottom_to_top.dart';
import 'package:wallpost/_common_widgets/filter_views/tab_chips.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/expense/expense_create/ui/views/create_expense_request_screen.dart';
import 'package:wallpost/expense/expense_list/ui/views/expense_list_screen.dart';

import '../../../../_common_widgets/screen_presenter/modal_sheet_presenter.dart';
import '../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../attendance/attendance_adjustment/ui/views/attendance_list_screen.dart';
import '../../../aggregated_approvals_list/ui/views/aggregated_approvals_list_screen.dart';
import '../presenters/owner_my_portal_dashboard_presenter.dart';
import '../view_contracts/owner_my_portal_view.dart';
import 'my_portal_dashboard_loader.dart';
import 'my_portal_item_action_view.dart';
import 'owner_my_portal_header_card.dart';
import 'owner_my_portal_todays_performance_view.dart';

class OwnerMyPortalDashboardScreen extends StatefulWidget {
  @override
  State<OwnerMyPortalDashboardScreen> createState() => _OwnerMyPortalDashboardScreenState();
}

class _OwnerMyPortalDashboardScreenState extends State<OwnerMyPortalDashboardScreen> implements OwnerMyPortalView {
  static const LOADER_VIEW = 1;
  static const ERROR_VIEW = 2;
  static const DATA_VIEW = 3;
  late OwnerMyPortalDashboardPresenter _presenter;

  var _errorMessage = "";
  var _viewTypeNotifier = ItemNotifier<int>(defaultValue: LOADER_VIEW);

  @override
  void initState() {
    _presenter = OwnerMyPortalDashboardPresenter(this);
    _presenter.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ItemNotifiable<int>(
      notifier: _viewTypeNotifier,
      builder: (context, viewType) {
        if (viewType == LOADER_VIEW) {
          return DashboardLoader();
        } else if (viewType == ERROR_VIEW) {
          return _errorAndRetryView();
        } else if (viewType == DATA_VIEW) {
          return _dataView();
        }
        return Container();
      },
    );
  }

  //MARK: Functions to build the error and retry view

  Widget _errorAndRetryView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: TextStyles.titleTextStyle,
              ),
              onPressed: () => _presenter.loadData(),
            ),
          ],
        ),
      ),
    );
  }

  //MARK: Functions to build the data views

  Widget _dataView() {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => _presenter.loadData(),
          child: ListView(
            padding: EdgeInsets.only(top: 0, bottom: 100),
            children: [
              OwnerMyPortalHeaderCard(_presenter.getFinancialSummary()),
              OwnerMyPerformanceTodaysPerformanceView(_presenter),
              SizedBox(height: 120),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [_bottomBar()],
        ),
      ],
    );
  }

  //MARK: Functions to build the bottom bar

  Widget _bottomBar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _requestsBar(),
        Container(height: 20, color: Colors.white),
        if (_presenter.getTotalApprovalCount() == 0) Container(height: 20, color: Colors.white),
        if (_presenter.getTotalApprovalCount() > 0)
          BottomBanner(
            approvalCount: _presenter.getTotalApprovalCount(),
            onTap: () => _presenter.goToAggregatedApprovalsScreen(),
          ),
      ],
    );
  }

  Widget _requestsBar() {
    if (_presenter.getRequestItems().isEmpty) return Container();

    return Stack(
      children: [
        CurveBottomToTop(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                "Requests",
                style: TextStyles.subTitleTextStyleBold.copyWith(color: AppColors.defaultColorDark),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 12),
              height: 52,
              color: Colors.white,
              child: TabChips(
                titles: _presenter.getRequestItems(),
                onItemSelected: (index) => _presenter.selectRequestItemAtIndex(index),
              ),
            ),
          ],
        ),
      ],
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

  @override
  void onDidLoadData() {
    _viewTypeNotifier.notify(DATA_VIEW);
  }

  @override
  void goToApprovalsListScreen(String companyId) {
    ScreenPresenter.present(AggregatedApprovalsListScreen(companyId: companyId), context);
  }

  @override
  void showLeaveActions() {
    //TODO
  }

  @override
  void showExpenseActions() {
    _presentActionSheet(ExpenseListScreen(), CreateExpenseRequestScreen());
  }

  @override
  void showPayrollAdjustmentActions() {
    ScreenPresenter.present(AttendanceListScreen(), context);
  }

  //MARK: Function to present action sheet

  void _presentActionSheet(Widget actionOneScreen, Widget actionTwoScreen) {
    var controller = ModalSheetController();
    ModalSheetPresenter.present(
      context: context,
      content: MyPortalItemActionView(
        actionOneTitle: "View",
        actionTwoTitle: "Create New",
        actionOneCallback: () async {
          await controller.close();
          ScreenPresenter.present(actionOneScreen, context);
        },
        actionTwoCallback: () async {
          await controller.close();
          ScreenPresenter.present(actionTwoScreen, context);
        },
      ),
      controller: controller,
    );
  }
}
