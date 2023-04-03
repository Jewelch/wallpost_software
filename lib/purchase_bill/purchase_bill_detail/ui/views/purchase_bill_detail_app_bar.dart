
import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_back_button.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class PurchaseBillDetailAppBar extends StatelessWidget {
  final String supplierName;


  PurchaseBillDetailAppBar({required this.supplierName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: AppColors.screenBackgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFEEEEEE),
            blurRadius: 0,
            offset: Offset(0, 1),
          ),
        ],

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RoundedBackButton(
                iconColor: AppColors.defaultColor,
                backgroundColor: Colors.white,
                onPressed: ()=> Navigator.pop(context),
              ),
              Text("Purchase Bill",style: TextStyles.titleTextStyle.copyWith(color: AppColors.defaultColor)),
            ],
          ),
          Container(
              margin: EdgeInsets.only(left: 16),
              child: Text(supplierName, style: TextStyles.extraLargeTitleTextStyleBold)),
          SizedBox(height: 8)
        ],
      ),
    );
  }
}
