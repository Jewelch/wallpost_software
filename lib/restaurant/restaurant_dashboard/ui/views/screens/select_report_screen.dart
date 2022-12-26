import 'package:blur/blur.dart';
import 'package:flutter/material.dart';

import '../../../../../_common_widgets/screen_presenter/screen_presenter.dart';
import '../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../_shared/constants/app_colors.dart';
import '../../../../sales_reports/item_sales/ui/views/screens/item_sales_screen.dart';
import '../../presenters/restaurant_dashboard_presenter.dart';

class SelectReportScreen extends StatefulWidget {
  final RestaurantDashboardPresenter presenter;

  const SelectReportScreen({Key? key, required this.presenter}) : super(key: key);

  @override
  State<SelectReportScreen> createState() => _SelectReportScreenState();
}

class _SelectReportScreenState extends State<SelectReportScreen> {
  bool isHourSalesSelected = false;
  bool isItemSalesSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: Navigator.of(context).pop,
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: Navigator.of(context).pop,
              ),
            ),
            Expanded(
                flex: 9,
                child: Stack(
                  children: [
                    Blur(
                      blur: 4,
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          color: AppColors.defaultColorDark.withOpacity(.4),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 1,
                      left: 1,
                      bottom: 32,
                      child: GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.4), borderRadius: BorderRadius.circular(24)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  "Sales Reports",
                                  style: TextStyles.extraLargeTitleTextStyleBold,
                                ),
                                SizedBox(
                                  height: 32,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isHourSalesSelected = false;
                                            isItemSalesSelected = true;
                                          });
                                        },
                                        child: Container(
                                          height: 64,
                                          decoration: BoxDecoration(
                                            color: isItemSalesSelected
                                                ? AppColors.defaultColorDarkContrastColor
                                                : AppColors.screenBackgroundColor,
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          child: Center(
                                              child: Text("Item Sales", style: TextStyles.subTitleTextStyleBold)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isHourSalesSelected = true;
                                            isItemSalesSelected = false;
                                          });
                                        },
                                        child: Container(
                                          height: 64,
                                          decoration: BoxDecoration(
                                            color: isHourSalesSelected
                                                ? AppColors.defaultColorDarkContrastColor
                                                : AppColors.screenBackgroundColor,
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Hourly Sales",
                                              style: TextStyles.subTitleTextStyleBold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 32,
                                ),
                                SizedBox(
                                  height: 48,
                                  width: double.maxFinite,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      ScreenPresenter.present(
                                        ItemSalesScreen(),
                                        context,
                                        slideDirection: SlideDirection.fromBottom,
                                      );
                                    },
                                    child: Text(
                                      "Reports",
                                      style: TextStyles.headerCardSubHeadingTextStyle,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
