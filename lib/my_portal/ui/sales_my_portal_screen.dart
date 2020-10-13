import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/wp_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_shared/network_adapter/exceptions/api_exception.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';
import 'package:wallpost/company_management/ui/companies_list_screen.dart';
import 'package:wallpost/dashboard/ui/left_menu_screen.dart';
import 'package:wallpost/my_portal/entities/pending_actions_count.dart';
import 'package:wallpost/my_portal/services/pending_actions_count_provider.dart';
import 'package:wallpost/my_portal/ui/performance/sales_performance_graph_view.dart';
import 'package:wallpost/my_portal/ui/financials/sales_financials_graph_view.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/my_portal/ui/approvals/pending_actions_count_view.dart';

class SalesMyPortalScreen extends StatefulWidget {
  @override
  _SalesMyPortalScreenState createState() => _SalesMyPortalScreenState();
}

class _SalesMyPortalScreenState extends State<SalesMyPortalScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  PendingActionsCount _pendingActionsCount;
  bool showError = false;

  @override
  void initState() {
    super.initState();
    _getPendingActionCount();
    _tabController = new TabController(length: 2, vsync: this);
  }

  void _getPendingActionCount() async {
    setState(() {
      _pendingActionsCount = null;
      showError = false;
    });

    try {
      var allCounts = await PendingActionsCountProvider().getCount();
      setState(() {
        _pendingActionsCount = allCounts;
      });
    } on APIException catch (_) {
      setState(() {
        showError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_pendingActionsCount != null) {
      return _buildSalesMyportalScreen();
    } else {
      return showError ? _buildErrorAndRetryView() : _buildProgressIndicator();
    }
  }

  Widget _buildSalesMyportalScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WPAppBar(
        title:
            SelectedCompanyProvider().getSelectedCompanyForCurrentUser().name,
        leading: RoundedIconButton(
          iconName: 'assets/icons/menu.svg',
          iconSize: 12,
          onPressed: () => ScreenPresenter.present(
            LeftMenuScreen(),
            context,
            slideDirection: SlideDirection.fromLeft,
          ),
        ),
        trailing: RoundedIconButton(
          iconName: 'assets/icons/filters_icon.svg',
          onPressed: () => {
            //TODO: Go to filters screen
          },
        ),
        showCompanySwitchButton: true,
        companySwitchBadgeCount: 10,
        onCompanySwitchButtonPressed: () {
          ScreenPresenter.present(CompaniesListScreen(), context,
              slideDirection: SlideDirection.fromLeft);
        },
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sales Performance',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                SizedBox(height: 8),
                SalesPerformanceGraphView(),
                SizedBox(height: 12),
                Divider(
                  height: 4,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Colors.grey[100], width: 2))),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black,
                    indicatorColor: AppColors.defaultColor,
                    indicatorWeight: 3,
                    tabs: [
                      Tab(
                        text: 'Financials',
                      ),
                      Tab(
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: 'Approvals ',
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text:
                                  '${_pendingActionsCount.taskApprovalsCount}',
                              style: TextStyle(
                                  color: AppColors.defaultColor,
                                  fontWeight: FontWeight.bold))
                        ])),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 350,
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      SalesFinancialsGraphView(),
                      PendingActionsCountView(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Center(
      child: Container(
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 30, height: 30, child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorAndRetryView() {
    return Container(
      height: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              child: Text(
                'Failed to performance\nTap Here To Retry',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              onPressed: () {
                setState(() {});
                _getPendingActionCount();
              },
            ),
          ],
        ),
      ),
    );
  }
}
