import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/finance/ui/views/finance_cash_monthly_list.dart';
import 'package:wallpost/finance/ui/views/finance_bill_details_view.dart';
import 'package:wallpost/finance/ui/views/finance_cash_detail_aggregated_view.dart';
import 'package:wallpost/finance/ui/views/finance_dashboard_details_view.dart';
import 'package:wallpost/finance/ui/views/finance_invoice_details_view.dart';
import 'package:wallpost/finance/ui/views/finance_tab_view.dart';
import 'package:wallpost/finance/ui/presenters/finance_dashboard_presenter.dart';
import 'package:wallpost/finance/ui/view_contracts/finance_dashboard_view.dart';
import 'package:wallpost/finance/ui/views/performance_view_holder.dart';

import 'finance_dashboard_app_bar.dart';
import 'finance_dashboard_loader.dart';
import 'finance_filters.dart';

class FinanceDashBoardScreen extends StatefulWidget {
  const FinanceDashBoardScreen({Key? key}) : super(key: key);

  @override
  State<FinanceDashBoardScreen> createState() => _FinanceDashBoardScreenState();
}

class _FinanceDashBoardScreenState extends State<FinanceDashBoardScreen> implements FinanceDashBoardView {
  late final FinanceDashboardPresenter presenter;
  final _viewTypeNotifier = ItemNotifier(defaultValue: LOADER_VIEW);
  static const LOADER_VIEW = 1;
  static const ERROR_VIEW = 2;
  static const DATA_VIEW = 3;
  var _errorMessage = "";

  @override
  void initState() {
    presenter = FinanceDashboardPresenter(this);
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
                FinanceDashboardAppBar(presenter),
                FinanceDashBoardDetailsView(presenter: presenter),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _buildBottomTabView(),
                    if (presenter.selectedModuleIndex == 0)
                      Positioned(top: 238, left: 0, right: 0, child: _buildMonthlyCashListView()),
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
            if (presenter.selectedModuleIndex == 0) _getCashDetailView(),
            if (presenter.selectedModuleIndex == 1) _titleText(title: "Invoices To Collect"),
            if (presenter.selectedModuleIndex == 2)  _titleText(title: "Bills To Pay"),
          ],
        ),
      ),
    );
  }

  Widget _getCashDetailView() {
    return Column(
      children: [
        SizedBox(height: 14),
        FinanceCashDetailAggregated(presenter: presenter),
        SizedBox(height: 14),
        _buildMonthlyCashListButtonView(),
        SizedBox(height: 14),
      ],
    );
  }

  _titleText({required String title}){
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 32),
      child: Text(title, style: TextStyles.extraLargeTitleTextStyleBold),
    );
  }


  Widget _buildMonthlyCashListButtonView() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _textButton(
              title: "Previous",
              icon: 'assets/icons/back_icon.svg',
              onPressed: () {
                presenter.onPreviousTextClick();
                setState(() {});
              }),
          Text('3 Months', style: TextStyles.subTitleTextStyle),
          _textButton(
              title: "Next",
              icon: 'assets/icons/arrow_right_icon.svg',
              onPressed: () {
                presenter.onNextTextClick();
                setState(() {});
              })
        ],
      ),
    );
  }

  Widget _textButton({required String title, required String icon, required VoidCallback onPressed}) {
    return Material(
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            if (title == "Next")
              Text(title, style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.defaultColor)),
            Container(
              height: 12,
              width: 12,
              child: SvgPicture.asset(icon, color: AppColors.defaultColor),
            ),
            if (title == "Previous")
              Text(title, style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.defaultColor))
          ],
        ),
      ),
    );
  }

  _buildMonthlyCashListView() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Container(
        height: 160,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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
          ],
        ),
        child: FinanceCashMonthlyList(presenter),
      ),
    );
  }

  _buildInvoiceView() {
    return Container(
      height: 180,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: PerformanceViewHolder(
        padding: EdgeInsets.all(8),
        content: FinanceInvoiceDetailsView(
          financeInvoiceDetails: presenter.getFinanceInvoiceReport()!,
        ),
      ),
    );
  }

  _buildBillView() {
    return Container(
      height: 180,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: PerformanceViewHolder(
        padding: EdgeInsets.all(8),
        content: FinanceBillDetailsView(
          financeBillDetails: presenter.getFinanceBillDetails()!,
        ),
      ),
    );
  }

  @override
  void showErrorAndRetryView(String message) {
    _viewTypeNotifier.notify(ERROR_VIEW);
    _errorMessage = message;
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
  void showFilters() async {
    await FinanceFilters.show(context,
        financePresenter: presenter, initialMonth: presenter.selectedMonth, initialYear: presenter.selectedYear);
  }
}
