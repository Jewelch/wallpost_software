import 'package:flutter/material.dart';

import '../../_common_widgets/buttons/rounded_back_button.dart';
import '../../_shared/constants/app_colors.dart';
import 'finance_boxes_view.dart';
import 'finance_inner_appbar.dart';

class FinanceInnerScreen extends StatelessWidget{
  const FinanceInnerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          _AppBar(),
          FinanceBoxesView()
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FinanceDetailAppBar(
      companyName:"Company name",
      onLeftMenuButtonPress: () => {},
      onAddButtonPress: () {},
      leadingButton: RoundedBackButton(backgroundColor: Colors.white,
          iconColor: AppColors.defaultColor,
          onPressed: () => Navigator.pop(context)),
      onTitlePress: () => Navigator.pop(context),
    );
  }
}