import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/wp_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_icon_button.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/network_adapter/exceptions/api_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/attendance/ui/attendance_base_view.dart';
import 'package:wallpost/company_list/ui/companies_list_screen.dart';
import 'package:wallpost/dashboard/ui/left_menu_screen.dart';
import 'package:wallpost/my_portal/entities/pending_actions_count.dart';
import 'package:wallpost/my_portal/services/pending_actions_count_provider.dart';
import 'package:wallpost/my_portal/ui/approvals/pending_actions_count_view.dart';
import 'package:wallpost/my_portal/ui/performance/employee_performance_graph_view.dart';

class EmployeeMyPortalScreen extends StatefulWidget {
  @override
  _EmployeeMyPortalScreenState createState() => _EmployeeMyPortalScreenState();
}

class _EmployeeMyPortalScreenState extends State<EmployeeMyPortalScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;
  PendingActionsCount _pendingActionsCount;
  num _totalpendingApprovalsCount = 0;

  @override
  void initState() {
    super.initState();
    _getPendingActionCount();
    _tabController = new TabController(length: 2, vsync: this);
  }

  void _getPendingActionCount() async {
    setState(() {
      _pendingActionsCount = null;
    });

    try {
      var allCounts = await PendingActionsCountProvider().getCount();
      setState(() {
        _pendingActionsCount = allCounts;
        _totalpendingApprovalsCount = _pendingActionsCount.totalPendingApprovals;
      });
    } on APIException catch (_) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WPAppBar(
        title: SelectedCompanyProvider().getSelectedCompanyForCurrentUser().shortName,
        leading: CircularIconButton(
          iconName: 'assets/icons/menu.svg',
          iconSize: 12,
          onPressed: () => ScreenPresenter.present(
            LeftMenuScreen(),
            context,
            slideDirection: SlideDirection.fromLeft,
          ),
        ),
        trailing: CircularIconButton(
          iconName: 'assets/icons/filters_icon.svg',
          onPressed: () => {
            //TODO: Go to filters screen
          },
        ),
        showCompanySwitchButton: true,
        companySwitchBadgeCount: 10,
        onCompanySwitchButtonPressed: () {
          ScreenPresenter.present(CompaniesListScreen(), context, slideDirection: SlideDirection.fromLeft);
        },
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  'Performance',
                  style: TextStyles.subTitleTextStyle,
                ),
                SizedBox(height: 16),
                EmployeePerformanceGraphView(),
                SizedBox(height: 20),
                Container(
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black,
                    indicatorColor: AppColors.defaultColor,
                    indicatorWeight: 3,
                    tabs: [
                      Tab(
                        child: Text(
                          'Attendance',
                          style: TextStyles.titleTextStyle,
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Approvals ', style: TextStyles.titleTextStyle),
                            Text(
                              '$_totalpendingApprovalsCount',
                              style: TextStyles.titleTextStyle.copyWith(color: AppColors.defaultColor),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.0),
                      border: Border(bottom: BorderSide(color: Colors.grey, width: 0.8))),
                ),
                Container(
                  height: 300,
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[AttendanceBaseView(), PendingActionsCountView()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
