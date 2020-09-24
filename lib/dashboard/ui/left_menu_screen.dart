import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/user_management/services/current_user_provider.dart';
import 'package:wallpost/authentication/services/logout_handler.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';

//TODO: Add loader when profile picture loads or add a placeholder image
class LeftMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
        title: getTitle(),
        leading: RoundedIconButton(
          iconName: 'assets/icons/back.svg',
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.defaultColor, width: 1),
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                      image: NetworkImage(CurrentUserProvider().getCurrentUser().profileImageUrl), fit: BoxFit.fill),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                CurrentUserProvider().getCurrentUser().fullName,
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 80),
            Row(
              children: [
                GestureDetector(
                  child: Container(
                    width: 70,
                    height: 70,
                    margin: EdgeInsets.only(left: 50),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.defaultColor, width: 2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/settings_icon.svg',
                          width: 25,
                          height: 25,
                        ),
                        Text('Settings', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                  onTap: () => {Navigator.of(context).pushNamed(RouteNames.settings)},
                ),
                Spacer(),
                Container(
                  width: 70,
                  height: 70,
                  margin: EdgeInsets.only(right: 50),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.defaultColor, width: 2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/info_icon.svg',
                        width: 25,
                        height: 25,
                      ),
                      Text('About', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            GestureDetector(
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.logoutRedColor, width: 2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/logout_icon.svg',
                      width: 25,
                      height: 25,
                    ),
                    Text('Logout', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
              onTap: () => LogoutHandler().logout(context),
            ),
          ],
        ),
      ),
    );
  }

  getTitle() {
    if (SelectedCompanyProvider().getSelectCompanyForCurrentUser() == null)
      return '';
    else
      return SelectedCompanyProvider().getSelectCompanyForCurrentUser().name;
  }
}
