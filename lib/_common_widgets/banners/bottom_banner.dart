import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../_shared/constants/app_colors.dart';
import '../text_styles/text_styles.dart';

class BottomBanner extends StatelessWidget {
  final int approvalCount;
  final VoidCallback onTap;

  BottomBanner({required this.approvalCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Platform.isAndroid ? 50 : 80,
        padding: EdgeInsets.only(bottom: Platform.isAndroid ? 0 : 30, left: 6, right: 6),
        decoration: BoxDecoration(
          color: AppColors.bannerBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.bannerBackgroundColor.withOpacity(0.9),
              offset: Offset(0, 0),
              blurRadius: 5,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 10),
            SvgPicture.asset('assets/icons/exclamation_icon.svg', color: Colors.white, width: 16, height: 16),
            SizedBox(width: 10),
            Text("Approvals", style: TextStyles.titleTextStyle.copyWith(color: Colors.white)),
            new Spacer(),
            Text("$approvalCount", style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(width: 10)
          ],
        ),
      ),
    );
  }
}
