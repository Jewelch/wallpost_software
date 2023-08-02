import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:notifiable/notifiable.dart';
import 'package:wallpost/finance/reports/balance_sheet/ui/presenters/balance_sheet_presenter.dart';
import 'package:wallpost/finance/reports/balance_sheet/ui/views/loader/balance_sheet_loader.dart';

import '../../../../../../_shared/constants/app_colors.dart';
import '../../view_contracts/balance_sheet_view.dart';
import '../widgets/balance_sheet_header_card.dart';
import '../widgets/balance_sheet_app_bar.dart';
import '../widgets/balance_sheet_error_view.dart';
import '../widgets/balance_sheet_items_list.dart';
import '../widgets/balance_sheet_reports_filters.dart';

enum _ScreenStates { loading, error, data }

class BalanceSheetScreen extends StatefulWidget {
  const BalanceSheetScreen({super.key});

  @override
  State<BalanceSheetScreen> createState() => _State();
}

class _State extends State<BalanceSheetScreen> implements BalanceSheetView {
  late BalanceSheetPresenter presenter = BalanceSheetPresenter(this);

  final screenStateNotifier = ItemNotifier<_ScreenStates>(defaultValue: _ScreenStates.data);
  final profitLossDataNotifier = Notifier();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    presenter.getBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ItemNotifiable<_ScreenStates>(
        notifier: screenStateNotifier,
        builder: (_, currentState) {
          switch (currentState) {
            //$ LOADING STATE
            case _ScreenStates.loading:
              return BalanceSheetLoader();

            //! ERROR STATE
            case _ScreenStates.error:
              return Scaffold(
                appBar: BalanceSheetAppBar(presenter),
                body: ProfitsLossesErrorView(
                  errorMessage: errorMessage,
                  onRetry: presenter.getBalance,
                ),
              );

            //* DATA STATE
            case _ScreenStates.data:
              return _DataView(
                presenter: presenter,
                profitLossDataNotifier: profitLossDataNotifier,
                context: context,
              );
          }
        },
      ),
    );
  }

  @override
  void showLoader() => screenStateNotifier.notify(_ScreenStates.loading);

  @override
  void showFilter() async {
    var newFilters = await ProfitsLossesReportsFilters.show(
      context,
      initialFilters: presenter.filters.copy(),
      onResetClicked: presenter.resetFilters,
    );
    presenter.applyFilters(newFilters);
  }

  @override
  void onDidLoadBalanceSheet() {
    screenStateNotifier.notify(_ScreenStates.data);
  }

  @override
  void showErrorMessage(String msg) {
    this.errorMessage = msg;
    screenStateNotifier.notify(_ScreenStates.error);
  }

  @override
  void onDidChangeFilters() {
    setState(() {});
  }
}

class _DataView extends StatelessWidget {
  const _DataView({
    required this.presenter,
    required this.profitLossDataNotifier,
    required this.context,
  });

  final BalanceSheetPresenter presenter;
  final Notifier profitLossDataNotifier;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BalanceSheetAppBar(presenter),
      body: RefreshIndicator(
        onRefresh: presenter.getBalance,
        child: Container(
          color: AppColors.screenBackgroundColor2,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Column(
              children: [
                SizedBox(height: 16),
                Notifiable(
                  notifier: profitLossDataNotifier,
                  builder: (context) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: BalanceSheetHeaderCard(presenter),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: BalanceSheetList(presenter),
                ),
                SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: ShareReportButton(presenter),
    );
  }
}
