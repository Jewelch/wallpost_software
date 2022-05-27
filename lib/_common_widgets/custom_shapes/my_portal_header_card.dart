import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../_shared/constants/app_colors.dart';
import '../text_styles/text_styles.dart';
import 'HeaderCardPainter.dart';

class MyPortalHeaderCard extends StatelessWidget {
  final Widget content;

  MyPortalHeaderCard({required this.content});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 340,
          margin: EdgeInsets.only(right: 0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.defaultColor.withOpacity(0.02),
                offset: Offset(0, 0),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: CustomPaint(
            painter: HeaderCardPainter(AppColors.defaultColor),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 45.0, left: 16.0),
                    child: Text(
                      "My YTD Performance",
                      style: TextStyles.titleTextStyle
                          .copyWith(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 45.0, right: 16.0),
                    child: Row(
                      children: [
                        Text(
                          "100%",
                          style: TextStyles.titleTextStyle
                              .copyWith(color: AppColors.headerCardSuccessColor, fontSize: 18.0,fontWeight : FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        SvgPicture.asset('assets/icons/right_arrow_icon.svg',
                            height: 16, width: 16, color: AppColors.headerCardSuccessColor)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 52,
          child: Container(
            width: 400,
            height: 290,
            child: CustomPaint(
              painter: HeaderCardPainter(AppColors.defaultColorDark),
              child: Container(
                child: content,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
