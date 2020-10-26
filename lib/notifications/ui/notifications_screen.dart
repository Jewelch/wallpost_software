import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/notifications/ui/my_portal_notification_view.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Notification',
        leading: RoundedIconButton(
          iconName: 'assets/icons/back.svg',
          iconSize: 12,
          onPressed: () => {},
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.grey[100], width: 2))),
                    child: TabBar(
                        controller: _tabController,
                        labelColor: AppColors.defaultColor,
                        unselectedLabelColor: Colors.black,
                        indicatorColor: AppColors.defaultColor,
                        indicatorWeight: 3,
                        tabs: [
                          Tab(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                Text('Task'),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  '12',
                                  style: TextStyle(
                                      color: AppColors.defaultColor,
                                      fontWeight: FontWeight.bold),
                                )
                              ])),
                          Tab(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                Text('My Portal'),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  '2',
                                  style: TextStyle(
                                      color: AppColors.defaultColor,
                                      fontWeight: FontWeight.bold),
                                )
                              ]))
                        ])),
                Container(
                  height: 350,
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      Text('ewfd'),
                      MyPortalNotificationView()
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
