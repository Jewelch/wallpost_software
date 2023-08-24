import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:notifiable/notifiable.dart';

import '../../../../../../_shared/constants/app_colors.dart';
import '../../presenters/payables_and_ageing_presenter.dart';
import '../../view_contracts/payables_and_ageing_view.dart';
import '../loader/payables_and_ageing_loader.dart';
import '../widgets/payables_header_card.dart';
import '../widgets/payables_app_bar.dart';
import '../widgets/payables_error_view.dart';
import '../widgets/payables_items_list.dart';

enum _ScreenStates { loading, error, data }

class PayablesScreen extends StatefulWidget {
  const PayablesScreen({super.key});

  @override
  State<PayablesScreen> createState() => _State();
}

class _State extends State<PayablesScreen> implements PayablesView {
  late PayablesPresenter presenter = PayablesPresenter(this);

  final screenStateNotifier = ItemNotifier<_ScreenStates>(defaultValue: _ScreenStates.data);
  final profitLossDataNotifier = Notifier();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    presenter.getPayables();
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
              return PayablesLoader();

            //! ERROR STATE
            case _ScreenStates.error:
              return Scaffold(
                appBar: PayablesAppBar(presenter),
                body: PayablesErrorView(
                  errorMessage: errorMessage,
                  onRetry: presenter.getPayables,
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
  void onDidLoadPayables() {
    screenStateNotifier.notify(_ScreenStates.data);
  }

  @override
  void showErrorMessage(String msg) {
    this.errorMessage = msg;
    screenStateNotifier.notify(_ScreenStates.error);
  }
}

class _DataView extends StatelessWidget {
  const _DataView({
    required this.presenter,
    required this.profitLossDataNotifier,
    required this.context,
  });

  final PayablesPresenter presenter;
  final Notifier profitLossDataNotifier;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor2,
      appBar: PayablesAppBar(presenter),
      body: RefreshIndicator(
        onRefresh: presenter.getPayables,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Column(
              children: [
                SizedBox(height: 16),
                Notifiable(
                  notifier: profitLossDataNotifier,
                  builder: (context) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: PayablesHeaderCard(presenter),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24, left: 24, right: 24),
                  child: PayablesList(presenter),
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
