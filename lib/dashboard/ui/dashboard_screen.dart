import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';
import 'package:wallpost/dashboard/ui/requests_screen.dart';
import 'package:wallpost/my_portal/ui/employee_my_portal_screen.dart';
import 'package:wallpost/my_portal/ui/sales_my_portal_screen.dart';
import 'package:wallpost/notifications/ui/notifications_screen.dart';

import 'modules_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  List<Widget> _screens = [];

  @override
  void initState() {
    _initScreens();
    super.initState();
  }

  void _initScreens() {
    var selectedCompany = SelectedCompanyProvider().getSelectCompanyForCurrentUser();
    if (selectedCompany.shouldShowRevenue) {
      _screens.add(SalesMyPortalScreen());
    } else {
      _screens.add(EmployeeMyPortalScreen());
    }
    _screens.add(ModulesScreen());
    _screens.add(RequestsScreen());
    _screens.add(NotificationsScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        splashColor: AppColors.defaultColor,
        child: SvgPicture.asset(
          'assets/icons/bottom_nav_new_icon.svg',
          height: 28,
          width: 28,
        ),
        onPressed: () {},
      ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            NavBarItem(
              iconName: 'assets/icons/bottom_nav_my_portal_icon.svg',
              title: 'My Portal',
              isSelected: _currentIndex == 0,
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            NavBarItem(
              iconName: 'assets/icons/bottom_nav_modules_icon.svg',
              title: 'Modules',
              isSelected: _currentIndex == 1,
              onPressed: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
            SizedBox(width: 32),
            NavBarItem(
              iconName: 'assets/icons/bottom_nav_requests_icon.svg',
              title: 'Requests',
              isSelected: _currentIndex == 2,
              onPressed: () {
                setState(() {
                  _currentIndex = 2;
                });
              },
            ),
            NavBarItem(
              iconName: 'assets/icons/bottom_nav_notifications_icon.svg',
              title: 'Notifications',
              isSelected: _currentIndex == 3,
              onPressed: () {
                setState(() {
                  _currentIndex = 3;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final String iconName;
  final String title;
  final bool isSelected;
  final VoidCallback onPressed;

  NavBarItem({this.iconName, this.title, this.isSelected, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 84,
      child: FlatButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.only(top: 10, bottom: 6, left: 0, right: 4),
        onPressed: onPressed,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                iconName,
                width: 20,
                height: 20,
                color: isSelected ? AppColors.defaultColor : Colors.black38,
              ),
              SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppColors.defaultColor : Colors.black38,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
