import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/finance/ui/views/finance_cash_monthly_list_card_view.dart';
import 'package:wallpost/finance/ui/views/finance_bill_card_view.dart';
import 'package:wallpost/finance/ui/views/finance_cash_card_view.dart';
import 'package:wallpost/finance/ui/views/finance_profit_loss_card_view.dart';
import 'package:wallpost/finance/ui/views/finance_invoice_card_view.dart';
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

  static const CASH_VIEW_INDEX = 0;
  static const INVOICE_VIEW_INDEX = 1;
  static const BILL_VIEW_INDEX = 2;

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
                FinanceProfitLossCardView(presenter: presenter),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _bottomCard(),
                    if (presenter.selectedModuleIndex == CASH_VIEW_INDEX)
                      Positioned(top: 236, left: 0, right: 0, child: _monthlyCashInOutListCard()),
                    if (presenter.selectedModuleIndex == INVOICE_VIEW_INDEX)
                      Positioned(top: 112, left: 0, right: 0, child: _invoiceCard()),
                    if (presenter.selectedModuleIndex == BILL_VIEW_INDEX)
                      Positioned(top: 112, left: 0, right: 0, child: _billCard())
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
  //MARK: Functions to build the bottom card view

  Widget _bottomCard() {
    return Padding(
      padding: const EdgeInsets.only(left: 16,right: 16,bottom: 16,top: 8),
      child: PerformanceViewHolder(
        content: Column(
          children: [
            FinanceHorizontalTab(presenter, () {
              setState(() {});
            }),
            if (presenter.selectedModuleIndex ==CASH_VIEW_INDEX) _cashCardData(),
            if (presenter.selectedModuleIndex == INVOICE_VIEW_INDEX) _titleText(title: "Invoices To Collect"),
            if (presenter.selectedModuleIndex == BILL_VIEW_INDEX)  _titleText(title: "Bills To Pay"),
          ],
        ),
      ),
    );
  }

  Widget _cashCardData() {
    return Column(
      children: [
        SizedBox(height: 14),
        FinanceCashCardView(presenter: presenter),
        SizedBox(height: 14),
        _monthlyCashInOutListHeader(),
        SizedBox(height: 14),
      ],
    );
  }

  _titleText({required String title}){
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 32),
      child: Text(title, style: TextStyles.extraLargeTitleTextStyleBold.copyWith(fontWeight: FontWeight.w500)),
    );
  }


  Widget _monthlyCashInOutListHeader() {
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
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            if (title == "Next")
              Text(title, style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.defaultColor)),
            Container(
              height: 10,
              width: 10,
              child: SvgPicture.asset(icon, color: AppColors.defaultColor),
            ),
            if (title == "Previous")
              Text(title, style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.defaultColor))
          ],
        ),
      ),
    );
  }

  _monthlyCashInOutListCard() {
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
        child: FinanceCashMonthlyListCardView(presenter),
      ),
    );
  }

  _invoiceCard() {
    return Container(
      height: 180,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: PerformanceViewHolder(
        padding: EdgeInsets.all(8),
        content: FinanceInvoiceCardView(
          financeInvoiceDetails: presenter.getFinanceInvoiceReport()!,
        ),
      ),
    );
  }

  _billCard() {
    return Container(
      height: 180,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: PerformanceViewHolder(
        padding: EdgeInsets.all(8),
        content: FinanceBillCardView(
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
