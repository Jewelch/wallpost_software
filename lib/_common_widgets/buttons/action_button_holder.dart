import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_action_button.dart';

import '../../_shared/constants/app_colors.dart';

class ActionButtonsHolder extends StatelessWidget {
  final int approvalCount;
  final VoidCallback onDidPressApprovalsButton;

  ActionButtonsHolder({
    required this.approvalCount,
    required this.onDidPressApprovalsButton,
  });

  @override
  Widget build(BuildContext context) {
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
  }

  Widget _approvalButton() {
    return RoundedRectangleActionButton(
      title: 'Approvals ($approvalCount)',
      backgroundColor: Color(0xFFFCF9E7),
      textColor: Color(0XFFF8A632),
      onPressed: () => onDidPressApprovalsButton(),
    );
  }
}
