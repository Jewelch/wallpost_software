import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class MyPortalItemActionView extends StatelessWidget {
  final String actionOneTitle;
  final String actionTwoTitle;
  final VoidCallback actionOneCallback;
  final VoidCallback actionTwoCallback;

  MyPortalItemActionView({
    required this.actionOneTitle,
    required this.actionTwoTitle,
    required this.actionOneCallback,
    required this.actionTwoCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: _tile(actionOneTitle, actionOneCallback)),
              SizedBox(width: 20),
              Expanded(child: _tile(actionTwoTitle, actionTwoCallback)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tile(String title, VoidCallback callback) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.listItemBorderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            offset: Offset(0, 0),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: callback,
            child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    title,
                    style: TextStyles.titleTextStyleBold,
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
