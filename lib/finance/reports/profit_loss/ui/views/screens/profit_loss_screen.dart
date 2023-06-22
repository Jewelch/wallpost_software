import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:notifiable/notifiable.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../../../../../_common_widgets/app_bars/sliver_app_bar_delegate.dart';
import '../../../../../../_shared/constants/app_colors.dart';
import '../../presenter/profit_loss_presenter.dart';
import '../../view_contracts/profit_loss_view.dart';
import '../loader/profit_loss_loader.dart';
import '../widgets/profit_loss_app_bar.dart';
import '../widgets/profit_loss_error_view.dart';
import '../widgets/profit_loss_header_card.dart';
import '../widgets/profit_loss_reports_filters.dart';
import '../widgets/profit_loss_items_list.dart';

enum _ScreenStates { loading, error, data }

class ProfitsLossesScreen extends StatefulWidget {
  const ProfitsLossesScreen({super.key});

  @override
  State<ProfitsLossesScreen> createState() => _State();
}

class _State extends State<ProfitsLossesScreen> implements ProfitsLossesView {
  late ProfitsLossesPresenter presenter = ProfitsLossesPresenter(this);

  final screenStateNotifier = ItemNotifier<_ScreenStates>(defaultValue: _ScreenStates.data);
  final profitLossDataNotifier = Notifier();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    presenter.loadProfitsLossesData();
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
              return ProfitsLossesLoader();

            //! ERROR STATE
            case _ScreenStates.error:
              return Scaffold(
                appBar: AppBarWidget(presenter),
                body: ProfitsLossesErrorView(
                  errorMessage: errorMessage,
                  onRetry: presenter.loadProfitsLossesData,
                ),
              );

            //* DATA STATE
            case _ScreenStates.data:
              return _dataView();
          }
        },
      ),
    );
  }

  Widget _dataView() {
    return Scaffold(
      appBar: AppBarWidget(presenter),
      body: RefreshIndicator(
        onRefresh: () => presenter.loadProfitsLossesData(),
        child: Container(
          color: AppColors.screenBackgroundColor2,
          child: CustomScrollView(
            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              MultiSliver(
                children: [
                  SliverToBoxAdapter(child: SizedBox(height: 16)),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverAppBarDelegate(
                      minHeight: 56 + 16,
                      maxHeight: 100,
                      child: Notifiable(
                        notifier: profitLossDataNotifier,
                        builder: (context) => LayoutBuilder(builder: (context, contraints) {
                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                            AppBarWidget.appbarNotifier.notify(contraints.maxHeight <= 100);
                          });
                          return Padding(
                            padding:
                                contraints.maxHeight > 100 ? EdgeInsets.symmetric(horizontal: 24) : EdgeInsets.zero,
                            child: ProfitsLossesHeaderCard(presenter, contraints.maxHeight),
                          );
                        }),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: ProfitsLossesExpansions(presenter),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 120),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: ShareReportButton(presenter),
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
  void onDidChangeFilters() {
    setState(() {});
  }

  @override
  void onDidLoadReport() {
    screenStateNotifier.notify(_ScreenStates.data);
  }

  @override
  void showErrorMessage(String msg) {
    this.errorMessage = msg;
    screenStateNotifier.notify(_ScreenStates.error);
  }
}
