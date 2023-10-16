import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/orders_summary/list/ui/views/screens/orders_summary_screen.dart';

import '../../../../../_common_widgets/screen_presenter/screen_presenter.dart';
import '../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../_shared/constants/app_colors.dart';
import '../../../../sales_reports/hourly_sales/ui/views/screens/hourly_sales_screen.dart';
import '../../../../sales_reports/item_sales/ui/views/screens/item_sales_screen.dart';
import '../../../../sales_reports/sales_summary/ui/views/screens/sales_summary_screen.dart';
import '../../presenters/dashboard_presenter.dart';

class SelectReportScreen extends StatefulWidget {
  final DashboardPresenter presenter;

  const SelectReportScreen({Key? key, required this.presenter}) : super(key: key);

  @override
  State<SelectReportScreen> createState() => _SelectReportScreenState();
}

class _SelectReportScreenState extends State<SelectReportScreen> {
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
                    bottom: 40,
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
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      splashColor: AppColors.defaultColor,
                                      onTap: () {
                                        ScreenPresenter.present(
                                          ItemSalesScreen(),
                                          context,
                                          slideDirection: SlideDirection.fromBottom,
                                        );
                                      },
                                      child: Container(
                                        height: 64,
                                        decoration: BoxDecoration(
                                          color: AppColors.screenBackgroundColor.withOpacity(.7),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child:
                                            Center(child: Text("Item Sales", style: TextStyles.subTitleTextStyleBold)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: InkWell(
                                      splashColor: AppColors.defaultColor,
                                      onTap: () {
                                        ScreenPresenter.present(
                                          HourlySalesScreen(),
                                          context,
                                          slideDirection: SlideDirection.fromBottom,
                                        );
                                      },
                                      child: Container(
                                        height: 64,
                                        decoration: BoxDecoration(
                                          color: AppColors.screenBackgroundColor.withOpacity(.7),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: Center(
                                            child: Text("Hourly Sales", style: TextStyles.subTitleTextStyleBold)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      splashColor: AppColors.defaultColor,
                                      onTap: () {
                                        ScreenPresenter.present(
                                          SummarySalesScreen(),
                                          context,
                                          slideDirection: SlideDirection.fromBottom,
                                        );
                                      },
                                      child: Container(
                                        height: 64,
                                        decoration: BoxDecoration(
                                          color: AppColors.screenBackgroundColor.withOpacity(.7),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: Center(
                                            child: Text("Sales Summary", style: TextStyles.subTitleTextStyleBold)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: InkWell(
                                      splashColor: AppColors.defaultColor,
                                      onTap: () {
                                        ScreenPresenter.present(
                                          OrdersSummaryScreen(),
                                          context,
                                          slideDirection: SlideDirection.fromBottom,
                                        );
                                      },
                                      child: Container(
                                        height: 64,
                                        decoration: BoxDecoration(
                                          color: AppColors.screenBackgroundColor.withOpacity(.7),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: Center(
                                            child: Text("Orders Summary", style: TextStyles.subTitleTextStyleBold)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              SizedBox(height: 32),
                              SizedBox(
                                height: 48,
                                width: double.maxFinite,
                                child: TextButton(
                                  onPressed: Navigator.of(context).pop,
                                  child: Text(
                                    "Close Menu",
                                    style: TextStyles.largeTitleTextStyleBold.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textColorBlueGray,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                                ),
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
