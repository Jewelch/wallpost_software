import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/finance/ui/finanace_cash_montly_list.dart';
import 'package:wallpost/finance/ui/finance_bill_details_view.dart';
import 'package:wallpost/finance/ui/finance_cash_detail_aggregated_view.dart';
import 'package:wallpost/finance/ui/finance_dashboard_details_view.dart';
import 'package:wallpost/finance/ui/finance_invoice_details_view.dart';
import 'package:wallpost/finance/ui/finance_tab_view.dart';
import 'package:wallpost/finance/ui/presenters/finance_dashboard_presenter.dart';
import 'package:wallpost/finance/ui/view_contracts/finance_dashboard_view.dart';

import '../../../dashboard/company_dashboard_owner_my_portal/ui/views/performance_view_holder.dart';
import '../../../restaurant/restaurant_dashboard/ui/views/widgets/sliver_sales_breakdowns_horizontal_list.dart';

import 'finance_dashboard_appbar.dart';
import 'finance_dashboard_loader.dart';
import 'finance_filters.dart';

class FinanceDashBoardScreen extends StatefulWidget {
  const FinanceDashBoardScreen({Key? key}) : super(key: key);

  @override
  State<FinanceDashBoardScreen> createState() => _FinanceDashBoardScreenState();
}

class _FinanceDashBoardScreenState extends State<FinanceDashBoardScreen> implements FinanceDashBoardView {
  late final FinanceDasBoardPresenter presenter;
  final _viewTypeNotifier = ItemNotifier(defaultValue: LOADER_VIEW);
  static const LOADER_VIEW = 1;
  static const ERROR_VIEW = 2;
  static const DATA_VIEW = 3;
  var _errorMessage = "";

  @override
  void initState() {
    presenter = FinanceDasBoardPresenter(this);
    presenter.loadFinanceDashBoardDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => presenter.loadFinanceDashBoardDetails(),
      child: Scaffold(
          backgroundColor: AppColors.screenBackgroundColor,
          body: SafeArea(
            child: ItemNotifiable<int>(
              notifier: _viewTypeNotifier,
              builder: (context, viewType) {
                if (viewType == LOADER_VIEW) return FinanceDashboardLoader();

                if (viewType == ERROR_VIEW) return _errorAndRetryView();

                if (viewType == DATA_VIEW) return _dataView();

                return Container();
              },
            ),
          )),
    );
  }

  //MARK: Functions to build the error and retry view

  Widget _errorAndRetryView() {
    return _errorButton(title: _errorMessage, onPressed: () => presenter.loadFinanceDashBoardDetails());
  }

  Widget _errorButton({required String title, required VoidCallback onPressed}) {
    return Container(
      child: Center(
        child: TextButton(
          child: Text(title, textAlign: TextAlign.center, style: TextStyles.titleTextStyle),
          onPressed: onPressed,
        ),
      ),
    );
  }

  Widget _dataView() {
    return SafeArea(
      child: Container(
        color: AppColors.screenBackgroundColor2,
        child: CustomScrollView(
          slivers: [
            MultiSliver(
              children: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverAppBarDelegate(
                    minHeight: 56 + 32 + 16,
                    maxHeight: 56 + 32 + 16,
                    child: FinanceDashboardAppBar(presenter),
                  ),
                ),
                FinanceDashBoardDetailsView(
                  profitAndLoss: presenter.getProfitAndLossDetails(),
                  income: presenter.getIncomeDetails(),
                  expense: presenter.getExpenseDetails(),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _buildBottomTabView(),
                    if (presenter.selectedModuleIndex == 0)
                      Positioned(top: 230, left: 0, right: 0, child: _buildMonthlyCashListView()),
                    if (presenter.selectedModuleIndex == 1)
                      Positioned(top: 120, left: 0, right: 0, child: _buildInvoiceView()),
                    if (presenter.selectedModuleIndex == 2)
                      Positioned(top: 120, left: 0, right: 0, child: _buildBillView())
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBottomTabView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PerformanceViewHolder(
        content: Column(
          children: [
            FinanceHorizontalTab(presenter, () {
              setState(() {});
            }),
            if (presenter.selectedModuleIndex == 0) getCashView(),
            if (presenter.selectedModuleIndex == 1) getInvoiceView(),
            if (presenter.selectedModuleIndex == 2) getBillView(),
          ],
        ),
      ),
    );
  }

  Widget getCashView() {
    return Column(
      children: [
        SizedBox(
          height: 14,
        ),
        FinanceCashDetailAggregated(
          bankAndCash: presenter.getBankAndCashDetails(),
          cashIn: presenter.getCahInDetails(),
          cashOut: presenter.getCashOutDetails(),
        ),
        SizedBox(
          height: 14,
        ),
        _buildMonthlyCashListHeadView(),
        SizedBox(
          height: 14,
        ),
      ],
    );
  }

  getInvoiceView() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 32),
      child: Text(
        'Invoices To Collect',
        style: TextStyles.extraLargeTitleTextStyleBold,
      ),
    );
  }

  getBillView() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 32),
      child: Text(
        'Bills To Pay',
        style: TextStyles.extraLargeTitleTextStyleBold,
      ),
    );
  }

  Widget _buildMonthlyCashListHeadView() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            child: InkWell(
              onTap: () {
                presenter.onPreviousTextClick();
                setState(() {});
              },
              child: Row(
                children: [
                  Container(
                    height: 14,
                    width: 14,
                    child: SvgPicture.asset(
                      'assets/icons/back_icon.svg',
                      color: AppColors.defaultColor,
                    ),
                  ),
                  SizedBox(width: 2),
                  Text(
                    'Previous',
                    style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.defaultColor),
                  ),
                ],
              ),
            ),
          ),
          Text('3 Months', style: TextStyles.subTitleTextStyle),
          Material(
            child: InkWell(
              onTap: () {
                presenter.onNextTextClick();
                setState(() {});
              },
              child: Row(
                children: [
                  Text(
                    "Next",
                    style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.defaultColor),
                  ),
                  SizedBox(width: 2),
                  Container(
                    height: 14,
                    width: 14,
                    child: SvgPicture.asset(
                      'assets/icons/arrow_right_icon.svg',
                      color: AppColors.defaultColor,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildMonthlyCashListView() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Container(
        height: 160,
          padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.defaultColorDarkContrastColor.withOpacity(0.5),
                offset: Offset(0, 0),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ]
               ,
          ),
        child: FinanceCashMonthlyList(presenter),
      ),
    );
  }

  _buildInvoiceView() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Container(
        height: 180,
        child: PerformanceViewHolder(
          padding: EdgeInsets.all(8),
          content: FinanceInvoiceDetailsView(
            financeInvoiceDetails: presenter.getFinanceInvoiceReport()!,
          ),
        ),
      ),
    );
  }

  _buildBillView() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Container(
        height: 180,
        child: PerformanceViewHolder(
          padding: EdgeInsets.all(8),
          content: FinanceBillDetailsView(
            financeBillDetails: presenter.getFinanceBillDetails()!,
          ),
        ),
      ),
    );
  }

  @override
  void showErrorAndRetryView(String message) {
    // TODO: implement showErrorAndRetryView
  }

  @override
  void showLoader() {
    _viewTypeNotifier.notify(LOADER_VIEW);
  }

  @override
  void onDidLoadFinanceDashBoardData() {
    _viewTypeNotifier.notify(DATA_VIEW);
  }

  @override
  void showFinanceDashboardFilter() async {
    await FinanceFilters.show(context, financePresenter: presenter);
  }
}
