import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class ForgotPasswordSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.successColor, width: 3), borderRadius: BorderRadius.circular(50)),
              child: Container(
                margin: EdgeInsets.all(10),
                child: SvgPicture.asset(
                  'assets/icons/check.svg',
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 30, left: 10, right: 10, top: 30),
              child: Text(
                'We have sent a password reset link to your email addresses. Please check your email account and click the password reset link to reset your password.',
                style: TextStyle(color: AppColors.labelColor, fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 10),
              child: FlatButton(
                child: Text(' Go Back to Login'),
                color: AppColors.successColor,
                textColor: Colors.white,
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: AppColors.successColor),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(RouteNames.login);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
