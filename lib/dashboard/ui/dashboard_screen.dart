import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallpost/_common_widgets/screen_presenter/popup_presenter.dart';
// import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/dashboard/ui/my_portal_screen.dart';
import 'package:wallpost/dashboard/ui/requests_screen.dart';
// import 'package:wallpost/my_portal/ui/employee_my_portal_screen.dart';
// import 'package:wallpost/my_portal/ui/sales_my_portal_screen.dart';
import 'package:wallpost/notifications/ui/views/notifications_screen.dart';

import 'modules_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // PopupMenu menu;
  int _currentIndex = 0;
  List<Widget> _screens = [];
  GlobalKey btnKey2 = GlobalKey();

  @override
  void initState() {
    _initScreens();
    super.initState();
  }

  // void onClickMenu(MenuItemProvider item) {
  //   if (item.menuTitle == 'Task') {
  //     Navigator.pushNamed(context, RouteNames.createTaskScreen);
  //   } else if (item.menuTitle == 'Leave') {
  //     Navigator.pushNamed(context, RouteNames.createLeaveScreen);
  //   }
  //   print('Click menu -> ${item.menuTitle}');
  // }

  void onDismiss() {
    print('Menu is closed');
  }

  void _initScreens() {
    _screens.add(MyPortalScreen());
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
        key: btnKey2,
        onPressed: () {
          _showCreateRequestPopup();
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: NavBarItem(
                iconName: 'assets/icons/bottom_nav_my_portal_icon.svg',
                title: 'My Portal',
                isSelected: _currentIndex == 0,
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
            ),
            Flexible(
              child: NavBarItem(
                iconName: 'assets/icons/bottom_nav_modules_icon.svg',
                title: 'Modules',
                isSelected: _currentIndex == 1,
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
            ),
            SizedBox(width: 32),
            Flexible(
              child: NavBarItem(
                iconName: 'assets/icons/bottom_nav_requests_icon.svg',
                title: 'Requests',
                isSelected: _currentIndex == 2,
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
              ),
            ),
            Flexible(
              child: NavBarItem(
                iconName: 'assets/icons/bottom_nav_notifications_icon.svg',
                title: 'Notifications',
                isSelected: _currentIndex == 3,
                onPressed: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateRequestPopup() {
    PopupPresenter.present(
      context: context,
      screen: Column(
        children: [
          Container(height: 150, color: Colors.red),
          Container(height: 150, color: Colors.green),
          Container(height: 150, color: Colors.yellow),
          Container(height: 150, color: Colors.blue),
          Container(height: 150, color: Colors.pinkAccent),
          Container(height: 150, color: Colors.amber),
          Container(height: 150, color: Colors.purple),
          Container(height: 150, color: Colors.grey),
          Container(height: 150, color: Colors.black),
        ],
      ),
      title: "Requests",
      onDoneButtonPressed: () {},
      onCloseButtonPressed: () {},
    );
  }
}

class NavBarItem extends StatelessWidget {
  final String iconName;
  final String title;
  final bool isSelected;
  final VoidCallback onPressed;

  NavBarItem({
    required this.iconName,
    required this.title,
    required this.isSelected,
    required this.onPressed,
  });

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
