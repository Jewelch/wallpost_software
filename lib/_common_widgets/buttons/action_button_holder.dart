import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_action_button.dart';

import '../../_shared/constants/app_colors.dart';

class ActionButtonsHolder extends StatelessWidget {
  final int approvalCount;

  //final int alertCount;
  //final int actionsCount;
  final VoidCallback onDidPressApprovalsButton;

  //final VoidCallback onDidPressActionsButton;
  //final VoidCallback onDidPressAlertsButton;
  ActionButtonsHolder({
    required this.approvalCount,
    //required this.alertCount,
    // required this.actionsCount,
    required this.onDidPressApprovalsButton,
    ////required this.onDidPressActionsButton,
    //required this.onDidPressAlertsButton,
  });

  @override
  Widget build(BuildContext context) {
    /* return Container(
      child: Row(
        children: [
          if (approvalCount > 0) _approvalButton(),
          if (alertCount > 0) _alertsButton(),
          if (actionsCount > 0) _actionsButton(),
        ],
      ),
    );*/
    return Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: EdgeInsets.only(bottom: Platform.isAndroid ? 0 : 30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFF8A632).withOpacity(0.3),
              const Color(0xFFBF0A0A).withOpacity(0.3),
              const Color(0xFF003C81).withOpacity(0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.defaultColorDarkContrastColor.withOpacity(0.3),
              offset: Offset(0, 0),
              blurRadius: 40,
              spreadRadius: 0,
            ),
          ],
        ),
        child: _approvalButton());
    /* child: Row(
        children: [
          _approvalButton(),
          //if (alertCount > 0) _alertsButton(),
          //if (actionsCount > 0) _actionsButton(),
        ],
      ),    );*/
  }

  Widget _approvalButton() {
    return RoundedRectangleActionButton(
      title: 'Approvals ($approvalCount)',
      backgroundColor: Color(0xFFFCF9E7),
      textColor: Color(0XFFF8A632),
      onPressed: () => onDidPressApprovalsButton(),
    );
  }

  Widget _alertsButton() {
    return Container();
  }

  Widget _actionsButton() {
    return Container();
  }
}
