import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class StockExpirationLoader extends StatelessWidget {
  const StockExpirationLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ShimmerEffect(
        child: ListView(
          children: [
            Container(
              height: 172,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.textColorBlack,
              ),
              child: Text(
                "QAR",
                style: TextStyles.smallLabelTextStyle.copyWith(
                  color: AppColors.textColorBlueGray,
                ),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 38,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.textColorBlack,
                    ),
                  ),
                  SizedBox(height: 14),
                  Container(
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.textColorBlack,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.textColorBlack,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.textColorBlack,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
