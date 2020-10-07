import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/wp_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';
import 'package:wallpost/company_management/ui/companies_list_screen.dart';
import 'package:wallpost/dashboard/ui/left_menu_screen.dart';
import 'package:wallpost/my_portal/ui/performance/employee_performance_graph_view.dart';

class EmployeeMyPortalScreen extends StatefulWidget {
  @override
  _EmployeeMyPortalScreenState createState() => _EmployeeMyPortalScreenState();
}

class _EmployeeMyPortalScreenState extends State<EmployeeMyPortalScreen> with SingleTickerProviderStateMixin {
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
        title: SelectedCompanyProvider().getSelectedCompanyForCurrentUser().name,
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
          ScreenPresenter.present(CompaniesListScreen(), context, slideDirection: SlideDirection.fromLeft);
        },
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(
                'Performance',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 8),
              EmployeePerformanceGraphView(),
              Container(
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black,
                  indicatorColor: AppColors.defaultColor,
                  indicatorWeight: 3,
                  tabs: [
                    Tab(
                      text: 'Attendance',
                    ),
                    Tab(
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(text: 'Approvals ', style: TextStyle(color: Colors.black)),
                        TextSpan(text: '12', style: TextStyle(color: AppColors.defaultColor))
                      ])),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.0),
                    border: Border(bottom: BorderSide(color: Colors.grey, width: 0.8))),
              ),
              Container(
                height: 80.0,
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    Text(
                      'Attendance Data',
                      textAlign: TextAlign.center,
                    ),
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
    );
  }
}
