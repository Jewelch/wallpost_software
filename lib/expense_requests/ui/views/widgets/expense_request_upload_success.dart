import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_action_button.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/expense_list/ui/views/screens/expense_list_screen.dart';

class ExpenseRequestSubmittedSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.successColor, width: 3),
                  borderRadius: BorderRadius.circular(50)),
              child: Container(
                margin: EdgeInsets.all(10),
                child: SvgPicture.asset(
                  'assets/icons/check_mark_icon.svg',
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 30, left: 10, right: 10, top: 30),
              child: Text(
                'Your expense request has been process successfully.',
                style: TextStyles.subTitleTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            RoundedRectangleActionButton(
              title: 'Go back',
              color: AppColors.successColor,
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ExpenseListScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
