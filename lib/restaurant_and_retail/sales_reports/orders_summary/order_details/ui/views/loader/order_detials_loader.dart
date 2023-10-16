import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class OrderDetailsLoader extends StatelessWidget {
  const OrderDetailsLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ShimmerEffect(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          children: [
            SizedBox(height: 16),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.textColorBlack,
                      ),
                      child: Text(
                        "25th Apr 2023 - 10:30 AM",
                        style: TextStyles.largeTitleTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.textColorBlack,
                      ),
                      child: Text(
                        "Dine In",
                        style: TextStyles.largeTitleTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.textColorBlack,
                          ),
                          child: Text(
                            "Total amount paid",
                            style: TextStyles.largeTitleTextStyle.copyWith(
                              color: AppColors.textColorBlueGray,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.textColorBlack,
                                ),
                                child: Text(
                                  4000.toString(),
                                  style: TextStyles.headerCardSubValueTextStyle.copyWith(
                                    color: AppColors.brightGreen,
                                    fontSize: 31.0,
                                  ),
                                ),
                              ),
                              Container(
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
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.textColorBlack),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.textColorBlack,
                        ),
                        child: Text(
                          "Dine ",
                          style: TextStyles.largeTitleTextStyle.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),
            Container(
              height: 240,
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
            SizedBox(height: 24),
            ...List.generate(
              4,
              (index) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.textColorBlack,
                    ),
                    child: Text(
                      "25th Apr 2023 - 10:30 AM",
                      style: TextStyles.largeTitleTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.textColorBlack,
                    ),
                    child: Text(
                      "Dine In",
                      style: TextStyles.largeTitleTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ).toList()
          ],
        ),
      ),
    );
  }


}
