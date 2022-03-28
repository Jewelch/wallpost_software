import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_icon_button.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/company_list/views/companies_list_screen.dart';

class PunchOutScreen extends StatefulWidget {
  const PunchOutScreen({Key? key}) : super(key: key);

  @override
  _PunchOutScreenState createState() => _PunchOutScreenState();
}

class _PunchOutScreenState extends State<PunchOutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Punch out screen',
        showDivider: true,
        leadingButtons: [
          CircularIconButton(
            color: Colors.white,
            iconColor: AppColors.defaultColor,
            iconName: 'assets/icons/close_icon.svg',
            onPressed: () => ScreenPresenter.presentAndRemoveAllPreviousScreens(
                CompanyListScreen(), context),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Text('Punch out screen'),
        ),
      ),
    );
  }
}
