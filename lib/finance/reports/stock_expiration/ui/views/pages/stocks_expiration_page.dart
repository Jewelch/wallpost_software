import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import '../../presenter/stock_expiration_presenter.dart';
import '../../view_contracts/stock_expiration_view.dart';
import '../loader/stock_expiration_loader.dart';
import '../widgets/stock_expiration_app_bar.dart';
import '../widgets/stock_expiration_error_view.dart';
import '../widgets/filters/select_expired_or_not.dart';
import '../widgets/stock_expiration_list.dart';

enum _ScreenStates { loading, error, data }

class StockExpirationPage extends StatefulWidget {
  const StockExpirationPage({super.key});

  @override
  State<StockExpirationPage> createState() => _StockExpirationPageState();
}

class _StockExpirationPageState extends State<StockExpirationPage> implements StocksExpirationView {
  late StocksExpirationPresenter presenter = StocksExpirationPresenter(this);
  final paginationNotifier = ItemNotifier<bool>(defaultValue: false);
  final screenStateNotifier = ItemNotifier<_ScreenStates>(defaultValue: _ScreenStates.loading);
  String errorMessage = "";
  final ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
    presenter.loadNext();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        presenter.loadNext();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ItemNotifiable<_ScreenStates>(
      notifier: screenStateNotifier,
      builder: (context, currentState) {
        // return StockExpirationLoader();
        switch (currentState) {
          //$ LOADING STATE
          case _ScreenStates.loading:
            return StockExpirationLoader();

          //! ERROR STATE
          case _ScreenStates.error:
            return StockExpirationErrorView(
              errorMessage: errorMessage,
              onRetry: presenter.loadNext,
            );

          //* DATA STATE
          case _ScreenStates.data:
            return _dataView();
        }
      },
    );
  }

  Widget _dataView() {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor2,
      appBar: StocksExpirationAppBar(presenter),
      body: ListView(
        controller: controller,
        children: [
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Show Expire Stocks",
              style: TextStyles.headerCardSubValueTextStyle.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 14),
          ExpiredOrNotFilter(presenter),
          SizedBox(height: 24),
          presenter.stocksExpiration.isEmpty
              ? Padding(
                  padding: EdgeInsets.only(top: 150),
                  child: Text(
                    "There are no stocks  for\nthe selected filters",
                    textAlign: TextAlign.center,
                    style: TextStyles.titleTextStyle,
                  ),
                )
              : StocksExpirationList(presenter),
          SizedBox(height: 20),
          ItemNotifiable<bool>(
            notifier: paginationNotifier,
            builder: ((context, value) => value
                ? Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                        child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(),
                    )),
                  )
                : SizedBox()),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  @override
  void onDidLoadReport() {
    screenStateNotifier.notify(_ScreenStates.data);
    paginationNotifier.notify(false);
  }

  @override
  void showNoStocksMessage() {
    screenStateNotifier.notify(_ScreenStates.data);
    paginationNotifier.notify(false);
  }

  @override
  void showLoader() => screenStateNotifier.notify(_ScreenStates.loading);

  @override
  void showErrorMessage(String msg) {
    this.errorMessage = msg;
    screenStateNotifier.notify(_ScreenStates.error);
    paginationNotifier.notify(false);
  }

  @override
  showPaginationLoader() {
    paginationNotifier.notify(true);
  }
}
