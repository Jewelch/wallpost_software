import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/CustomSwitch.dart';
import 'package:wallpost/_common_widgets/app_bars/wp_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';

class RequestsScreen extends StatefulWidget {
  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  @override
  bool _enable = false;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WPAppBar(
        title:
            SelectedCompanyProvider().getSelectedCompanyForCurrentUser().name,
        leading: RoundedIconButton(
          iconName: 'assets/icons/back.svg',
          iconSize: 12,
          onPressed: () => {},
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      Text(
                        'Requests',
                        style: TextStyles.titleTextStyle,
                      ),
                      Spacer(),
                      CustomSwitch(
                        value: _enable,
                        onChanged: (bool val) {
                          setState(() {
                            _enable = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
              buildRequestsButton('Task', 'tasks_icon.svg',
                  () => {Navigator.pushNamed(context, RouteNames.task)}),
              buildRequestsButton('Leave', 'leave_icon.svg',
                  () => {Navigator.pushNamed(context, RouteNames.leaveList)}),
              buildRequestsButton('Expense', 'expense_icon.svg', () => {}),
              buildRequestsButton('Overtime', 'overtime_icon.svg', () => {}),
              buildRequestsButton(
                  'Attendance Adjustment', 'attendance_icon.svg', () => {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRequestsButton(
      String buttonTitle, String buttonIcon, VoidCallback _onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: SizedBox(
                  width: 30,
                  child: SvgPicture.asset('assets/icons/$buttonIcon',
                      width: 30, height: 30),
                ),
              ),
              Text(
                buttonTitle,
                style: TextStyles.listButtonTextStyle,
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: AppColors.defaultColor,
                  child: Center(
                    child: Text(
                      "3",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ]),
          ),
          Divider(),
        ],
      ),
    );
  }
}
