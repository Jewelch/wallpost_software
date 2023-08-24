import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:notifiable/notifiable.dart';

import '../../../../../../_shared/constants/app_colors.dart';
import '../../presenters/receivables_and_ageing_presenter.dart';
import '../../view_contracts/receivables_and_ageing_view.dart';
import '../loader/receivables_and_ageing_loader.dart';
import '../widgets/receivables_header_card.dart';
import '../widgets/receivables_app_bar.dart';
import '../widgets/receivables_error_view.dart';
import '../widgets/receivables_items_list.dart';

enum _ScreenStates { loading, error, data }

class ReceivablesScreen extends StatefulWidget {
  const ReceivablesScreen({super.key});

  @override
  State<ReceivablesScreen> createState() => _State();
}

class _State extends State<ReceivablesScreen> implements ReceivablesView {
  late ReceivablesPresenter presenter = ReceivablesPresenter(this);

  final screenStateNotifier = ItemNotifier<_ScreenStates>(defaultValue: _ScreenStates.data);
  final profitLossDataNotifier = Notifier();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    presenter.getReceivables();
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
              return ReceivablesLoader();

            //! ERROR STATE
            case _ScreenStates.error:
              return Scaffold(
                appBar: ReceivablesAppBar(presenter),
                body: ReceivablesErrorView(
                  errorMessage: errorMessage,
                  onRetry: presenter.getReceivables,
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
  void onDidLoadReceivables() {
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

  final ReceivablesPresenter presenter;
  final Notifier profitLossDataNotifier;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor2,
      appBar: ReceivablesAppBar(presenter),
      body: RefreshIndicator(
        onRefresh: presenter.getReceivables,
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
                    child: ReceivablesHeaderCard(presenter),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24, left: 24, right: 24),
                  child: ReceivablesList(presenter),
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
