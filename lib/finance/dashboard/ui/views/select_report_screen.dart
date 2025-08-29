import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:wallpost/finance/reports/payables_and_ageing/ui/views/screens/payables_screen.dart';

import '../../../../../_common_widgets/screen_presenter/screen_presenter.dart';
import '../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../_shared/constants/app_colors.dart';
import '../../../reports/balance_sheet/ui/views/screens/balance_sheet_screen.dart';
import '../../../reports/inventory_stock_report/ui/views/inventory_stock_report_screen.dart';
import '../../../reports/profit_loss/ui/views/screens/profit_loss_screen.dart';
import '../../../reports/receivables_and_ageing/ui/views/screens/receivables_screen.dart';
import '../../../reports/stock_expiration/ui/views/pages/stocks_expiration_page.dart';

class SelectReportScreen extends StatefulWidget {
  const SelectReportScreen({Key? key}) : super(key: key);

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
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * .8,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.4), borderRadius: BorderRadius.circular(24)),
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: [
                                SizedBox(height: 16),
                                Text("Reports", style: TextStyles.extraLargeTitleTextStyleBold),
                                SizedBox(height: 32),
                                InkWell(
                                  splashColor: AppColors.defaultColor,
                                  onTap: () {
                                    ScreenPresenter.present(
                                      InventoryStockReportScreen(),
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
                                    child: Center(child: Text("Stock", style: TextStyles.subTitleTextStyleBold)),
                                  ),
                                ),
                                SizedBox(height: 16),
                                InkWell(
                                  splashColor: AppColors.defaultColor,
                                  onTap: () {
                                    ScreenPresenter.present(
                                      ProfitsLossesScreen(),
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
                                        Center(child: Text("Profit & Loss", style: TextStyles.subTitleTextStyleBold)),
                                  ),
                                ),
                                SizedBox(height: 16),
                                InkWell(
                                  splashColor: AppColors.defaultColor,
                                  onTap: () {
                                    ScreenPresenter.present(
                                      BalanceSheetScreen(),
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
                                        Center(child: Text("Balance Sheet", style: TextStyles.subTitleTextStyleBold)),
                                  ),
                                ),
                                SizedBox(height: 16),
                                InkWell(
                                  splashColor: AppColors.defaultColor,
                                  onTap: () {
                                    ScreenPresenter.present(
                                      ReceivablesScreen(),
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
                                        child: Text("Receivables & Ageing", style: TextStyles.subTitleTextStyleBold)),
                                  ),
                                ),
                                SizedBox(height: 16),
                                //TODO: Enable once API is available on PRODUCTION
                                if (false)
                                  InkWell(
                                    splashColor: AppColors.defaultColor,
                                    onTap: () {
                                      ScreenPresenter.present(
                                        StockExpirationPage(),
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
                                          Center(child: Text("Stock Expire", style: TextStyles.subTitleTextStyleBold)),
                                    ),
                                  ),
                                //TODO: Enable once API is available on PRODUCTION
                                if (false) SizedBox(height: 16),
                                InkWell(
                                  splashColor: AppColors.defaultColor,
                                  onTap: () {
                                    ScreenPresenter.present(
                                      PayablesScreen(),
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
                                        child: Text("Payables & Ageing", style: TextStyles.subTitleTextStyleBold)),
                                  ),
                                ),
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
