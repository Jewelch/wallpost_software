import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/wp_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';
import 'package:wallpost/company_management/ui/companies_list_screen.dart';
import 'package:wallpost/dashboard/ui/left_menu_screen.dart';
import 'package:wallpost/my_portal/ui/performance/sales_performance_graph_view.dart';
import 'package:wallpost/my_portal/ui/financials/sales_financials_graph_view.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class SalesMyPortalScreen extends StatefulWidget {
  @override
  _SalesMyPortalScreenState createState() => _SalesMyPortalScreenState();
}

class _SalesMyPortalScreenState extends State<SalesMyPortalScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WPAppBar(
        title: SelectedCompanyProvider().getSelectCompanyForCurrentUser().name,
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
                SizedBox(height: 8),
                Divider(
                  height: 4,
                ),
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.defaultColor,
                  unselectedLabelColor: Colors.black,
                  indicatorColor: AppColors.defaultColor,
                  indicatorWeight: 3,
                  tabs: [
                    Tab(
                      text: 'Financials',
                    ),
                    Tab(
                      text: 'Approvals 12',
                    ),
                  ],
                ),
                Container(
                  height: 350,
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      SalesFinancialsGraphView(),
                      Text(
                        'Approvals Data',
                        textAlign: TextAlign.center,
                      ),
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
}
