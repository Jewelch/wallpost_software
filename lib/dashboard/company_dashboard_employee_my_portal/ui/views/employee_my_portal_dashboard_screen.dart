import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/screen_presenter/modal_sheet_presenter.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/leave/leave_create/ui/views/create_leave_screen.dart';
import 'package:wallpost/leave/leave_list/ui/views/leave_list_screen.dart';

import '../../../../../_shared/constants/app_colors.dart';
import '../../../../_common_widgets/banners/bottom_banner.dart';
import '../../../../_common_widgets/custom_shapes/curve_bottom_to_top.dart';
import '../../../../_common_widgets/filter_views/tab_chips.dart';
import '../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../attendance/attendance_adjustment/ui/views/attendance_list_screen.dart';
import '../../../../attendance/attendance_punch_in_out/ui/views/attendance_widget/attendance_widget.dart';
import '../../../../expense/expense_create/ui/views/create_expense_request_screen.dart';
import '../../../../expense/expense_list/ui/views/expense_list_screen.dart';
import '../../../aggregated_approvals_list/ui/views/aggregated_approvals_list_screen.dart';
import '../../../company_dashboard/ui/common_views/my_portal_item_action_view.dart';
import '../presenters/employee_my_portal_dashboard_presenter.dart';
import '../view_contracts/employee_my_portal_view.dart';
import 'employee_dashboard_loader.dart';
import 'employee_my_portal_header_card.dart';

class EmployeeMyPortalDashboardScreen extends StatefulWidget {
  @override
  State<EmployeeMyPortalDashboardScreen> createState() => _EmployeeMyPortalDashboardScreenState();
}

class _EmployeeMyPortalDashboardScreenState extends State<EmployeeMyPortalDashboardScreen>
    with WidgetsBindingObserver
    implements EmployeeMyPortalView {
  static const LOADER_VIEW = 1;
  static const ERROR_VIEW = 2;
  static const DATA_VIEW = 3;
  late EmployeeMyPortalDashboardPresenter _presenter;

  var _errorMessage = "";
  var _viewTypeNotifier = ItemNotifier<int>(defaultValue: LOADER_VIEW);

  @override
  void initState() {
    _presenter = EmployeeMyPortalDashboardPresenter(this);
    _presenter.loadData();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
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
          return EmployeeDashboardLoader();
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
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Text(
            "My Portal",
            style: TextStyles.extraLargeTitleTextStyleBold.copyWith(color: AppColors.myPortalColor),
          ),
        ),
        RefreshIndicator(
          onRefresh: () => _presenter.loadData(),
          child: ListView(
            padding: EdgeInsets.only(top: 20, bottom: 100),
            children: [
              EmployeeMyPortalHeaderCard(_presenter),
              SizedBox(height: 100),
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
        SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: AttendanceWidget(),
        ),
        SizedBox(height: 40),
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
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 16),
              width: double.infinity,
              child: Text(
                "Requests",
                style: TextStyles.subTitleTextStyleBold.copyWith(color: AppColors.defaultColorDark),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 12),
              height: 60,
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
