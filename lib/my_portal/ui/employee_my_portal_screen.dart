import 'package:flutter/material.dart';
import 'package:wallpost/my_portal/ui/performance/employee_my_portal_performance.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class EmployeeMyPortalScreen extends StatefulWidget {
  @override
  _EmployeeMyPortalScreenState createState() => _EmployeeMyPortalScreenState();
}

class _EmployeeMyPortalScreenState extends State<EmployeeMyPortalScreen>
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
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Align(alignment: Alignment.topLeft, child: Text('Performance')),
              EmployeeMyPortalPerformance(),
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
                        TextSpan(
                            text: 'Approvals ',
                            style: TextStyle(color: Colors.black)),
                        TextSpan(
                            text: '12',
                            style: TextStyle(color: AppColors.defaultColor))
                      ])),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.0),
                    border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.8))),
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
