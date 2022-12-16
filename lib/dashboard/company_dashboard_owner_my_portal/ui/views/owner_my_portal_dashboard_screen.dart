import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/views/modules_view.dart';
import 'package:wallpost/dashboard/finance_detail_views/ui/views/finance_detail_card.dart';
import 'package:wallpost/expense/expense_create/ui/views/create_expense_request_screen.dart';
import 'package:wallpost/expense/expense_list/ui/views/expense_list_screen.dart';
import 'package:wallpost/leave/leave_create/ui/views/create_leave_screen.dart';
import 'package:wallpost/leave/leave_list/ui/views/leave_list_screen.dart';

import '../../../../_common_widgets/buttons/action_button_holder.dart';
import '../../../../_common_widgets/filter_views/ytd_filter.dart';
import '../../../../_common_widgets/screen_presenter/modal_sheet_presenter.dart';
import '../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../attendance/attendance_adjustment/ui/views/attendance_list_screen.dart';
import '../../../../finance/ui/views/finance_dashboard_screen.dart';
import '../../../aggregated_approvals_list/ui/views/aggregated_approvals_list_screen.dart';
import '../../../company_dashboard/ui/common_views/my_portal_item_action_view.dart';
import '../presenters/module_page_view_presenter.dart';
import '../presenters/owner_my_portal_dashboard_presenter.dart';
import '../view_contracts/owner_my_portal_view.dart';
import 'company_performance_view.dart';
import 'lix_view.dart';
import 'owner_dashboard_loader.dart';

class OwnerMyPortalDashboardScreen extends StatefulWidget {
  @override
  State<OwnerMyPortalDashboardScreen> createState() => _OwnerMyPortalDashboardScreenState();
}

class _OwnerMyPortalDashboardScreenState extends State<OwnerMyPortalDashboardScreen>
    with WidgetsBindingObserver
    implements OwnerMyPortalView {
  static const LOADER_VIEW = 1;
  static const ERROR_VIEW = 2;
  static const DATA_VIEW = 3;
  late OwnerMyPortalDashboardPresenter _presenter;
  final _moduleViewPresenter = ModulePageViewPresenter();

  var _errorMessage = "";
  var _viewTypeNotifier = ItemNotifier<int>(defaultValue: LOADER_VIEW);
  Timer? _backgroundSyncTimer;

  @override
  void initState() {
    _presenter = OwnerMyPortalDashboardPresenter(this);
    _presenter.loadData();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    _backgroundSyncTimer?.cancel();
    _presenter.stopListeningToNotifications();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) _presenter.syncDataInBackground();
  }

  @override
  Widget build(BuildContext context) {
    return ItemNotifiable<int>(
      notifier: _viewTypeNotifier,
      builder: (context, viewType) {
        if (viewType == LOADER_VIEW) {
          return OwnerDashboardLoader();
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
            padding: EdgeInsets.only(top: 44, bottom: 100),
            children: [
              GestureDetector(
                  onTap: () => ScreenPresenter.present(FinanceDashBoardScreen(), context),
                  child: FinanceDetailCard(_presenter.getFinancialSummary())),
              ModulesView(_moduleViewPresenter, _presenter.filters),
              SizedBox(height: 16),
              _buildHrPerformanceView(),
              SizedBox(height: 120),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "My Portal",
                style: TextStyles.extraLargeTitleTextStyleBold.copyWith(color: AppColors.myPortalColor),
              ),
              YtdFilter(
                initialMonth: _presenter.selectedMonth,
                initialYear: _presenter.selectedYear,
                onDidChangeFilter: (month, year) {
                  _presenter.setFilter(month: month, year: year);
                },
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [if (_presenter.getTotalApprovalCount() > 0) _bottomView()],
        ),
      ],
    );
  }

  Widget _buildHrPerformanceView() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      height: 200,
      child: Column(
        children: [
          Expanded(child: CompanyPerformanceView(_presenter)),
          SizedBox(height: 8),
          Expanded(child: LixView()),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  //MARK: Functions to build the approval button

  Widget _bottomView() {
    return Container(
      color: Colors.white,
      child: Padding(
          padding: EdgeInsets.only(left: 12, right: 12),
          child: ActionButtonsHolder(
              approvalCount: _presenter.getTotalApprovalCount(),
              onDidPressApprovalsButton: () => _presenter.goToAggregatedApprovalsScreen())),
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
    _startSyncingDataAtRegularIntervals();
  }

  void _startSyncingDataAtRegularIntervals() {
    if (_backgroundSyncTimer == null || _backgroundSyncTimer!.isActive == false) {
      _backgroundSyncTimer = new Timer.periodic(const Duration(seconds: 30), (Timer timer) {
        _presenter.syncDataInBackground();
      });
    }
  }

  @override
  void goToApprovalsListScreen(String companyId) {
    ScreenPresenter.present(
      AggregatedApprovalsListScreen(companyId: companyId),
      context,
    ).then((_) => _presenter.syncDataInBackground());
  }

  @override
  void showLeaveActions() {
    _presentActionSheet(LeaveListScreen(), CreateLeaveScreen());
  }

  @override
  void showExpenseActions() {
    _presentActionSheet(ExpenseListScreen(), CreateExpenseRequestScreen());
  }

  @override
  void showPayrollAdjustmentActions() {
    ScreenPresenter.present(
      AttendanceListScreen(),
      context,
    ).then((_) => _presenter.syncDataInBackground());
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
          ScreenPresenter.present(
            actionOneScreen,
            context,
          ).then((_) => _presenter.syncDataInBackground());
        },
        actionTwoCallback: () async {
          await controller.close();
          ScreenPresenter.present(
            actionTwoScreen,
            context,
          ).then((_) => _presenter.syncDataInBackground());
        },
      ),
      controller: controller,
    );
  }
}
