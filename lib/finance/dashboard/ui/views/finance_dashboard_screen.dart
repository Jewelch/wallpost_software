import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/finance/dashboard/ui/presenters/finance_dashboard_presenter.dart';
import 'package:wallpost/finance/dashboard/ui/view_contracts/finance_dashboard_view.dart';
import 'package:wallpost/finance/dashboard/ui/views/finance_bill_card_view.dart';
import 'package:wallpost/finance/dashboard/ui/views/finance_cash_card_view.dart';
import 'package:wallpost/finance/dashboard/ui/views/finance_cash_monthly_list_card_view.dart';
import 'package:wallpost/finance/dashboard/ui/views/finance_invoice_card_view.dart';
import 'package:wallpost/finance/dashboard/ui/views/finance_profit_loss_card_view.dart';
import 'package:wallpost/finance/dashboard/ui/views/finance_tab_view.dart';
import 'package:wallpost/finance/dashboard/ui/views/report_floating_action_button.dart';

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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.screenBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () async => presenter.loadFinanceDashBoardDetails(),
        child: SafeArea(
          child: ItemNotifiable<int>(
            notifier: _viewTypeNotifier,
            builder: (context, viewType) {
              if (viewType == LOADER_VIEW) return FinanceDashboardLoader();

              if (viewType == ERROR_VIEW) return _errorAndRetryView();

              if (viewType == DATA_VIEW) return _dataView();

              return Container();
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ReportsFloatingActionButton(),
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
    return Container(
      color: AppColors.screenBackgroundColor2,
      child: Column(
        children: [
          FinanceDashboardAppBar(presenter),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FinanceProfitLossCardView(presenter: presenter),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          child: _bottomCard(),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  offset: Offset(0, -1),
                                  spreadRadius: 0,
                                  blurRadius: 3),
                            ],
                          ),
                          child: Column(
                            children: [
                              if (presenter.selectedModuleIndex == CASH_VIEW_INDEX) _monthlyCashInOutListCard(),
                              if (presenter.selectedModuleIndex == INVOICE_VIEW_INDEX) _invoiceCard(),
                              if (presenter.selectedModuleIndex == BILL_VIEW_INDEX) _billCard()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 200),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  //MARK: Functions to build the bottom card view

  Widget _bottomCard() {
    return Column(
      children: [
        FinanceHorizontalTab(presenter, () {
          setState(() {});
        }),
        if (presenter.selectedModuleIndex == CASH_VIEW_INDEX) _cashCardData(),
        if (presenter.selectedModuleIndex == INVOICE_VIEW_INDEX) _titleText(title: "Invoices To Collect"),
        if (presenter.selectedModuleIndex == BILL_VIEW_INDEX) _titleText(title: "Bills To Pay"),
      ],
    );
  }

  Widget _cashCardData() {
    return Column(
      children: [
        SizedBox(height: 14),
        FinanceCashCardView(presenter: presenter),
        SizedBox(height: 22),
        _monthlyCashInOutListHeader(),
      ],
    );
  }

  _titleText({required String title}) {
    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: 8),
      child: Text(title, style: TextStyles.extraLargeTitleTextStyleBold.copyWith(fontWeight: FontWeight.w500)),
    );
  }

  Widget _monthlyCashInOutListHeader() {
    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 40,
            child: _textButton(
                title: "Previous",
                icon: 'assets/icons/back_icon.svg',
                onPressed: () {
                  presenter.onPreviousTextClick();
                  setState(() {});
                }),
          ),
          Text('3 Months', style: TextStyles.subTitleTextStyle.copyWith(fontSize: 15.0)),
          SizedBox(
            height: 40,
            child: _textButton(
                title: "Next",
                icon: 'assets/icons/arrow_right_icon.svg',
                onPressed: () {
                  presenter.onNextTextClick();
                  setState(() {});
                }),
          )
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
              Text(title, style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.defaultColor, fontSize: 15.0)),
            Container(
              height: 10,
              width: 10,
              child: SvgPicture.asset(
                icon,
                colorFilter: ColorFilter.mode(AppColors.defaultColor, BlendMode.srcIn),
              ),
            ),
            if (title == "Previous")
              Text(title, style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.defaultColor, fontSize: 15.0))
          ],
        ),
      ),
    );
  }

  _monthlyCashInOutListCard() {
    return Container(
      height: 150,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: FinanceCashMonthlyListCardView(presenter),
    );
  }

  _invoiceCard() {
    return Container(
      height: 200,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: FinanceInvoiceCardView(
        financeInvoiceDetails: presenter.getFinanceInvoiceReport()!,
      ),
    );
  }

  _billCard() {
    return Container(
      height: 200,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: FinanceBillCardView(
        financeBillDetails: presenter.getFinanceBillDetails()!,
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
