import 'package:flutter/material.dart';
import 'package:wallpost/my_portal/ui/performance/sales_my_portal_performance.dart';
import 'package:wallpost/my_portal/ui/financial_tab/sales_my_portal_financial_screen.dart';
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
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Text('Sales Performance',
                        style: TextStyle(color: AppColors.labelColor))),
                SalesMyPortalPerormance(),
                Divider(
                  height: 5,
                ),
                Container(
                  child: TabBar(
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
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.0),
                      border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 0.8))),
                ),
                Container(
                  height: 350,
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      SalesMyPortalFinancialScreen(),
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
