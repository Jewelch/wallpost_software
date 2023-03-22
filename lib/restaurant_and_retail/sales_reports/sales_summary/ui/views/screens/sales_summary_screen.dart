import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:notifiable/notifiable.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:wallpost/_shared/date_range_selector/date_custom_range_selector.dart';

import '../../../../../../_common_widgets/app_bars/sliver_app_bar_delegate.dart';
import '../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../_shared/constants/app_colors.dart';
import '../../presenter/sales_summary_presenter.dart';
import '../../view_contracts/sales_summary_view.dart';
import '../loader/sales_summary_loader.dart';
import '../widgets/sales_summary_app_bar.dart';
import '../widgets/sales_summary_data_card_view.dart';
import '../widgets/sales_summary_error_view.dart';
import '../widgets/sales_summary_header_card.dart';

enum _ScreenStates { loading, error, data }

class SummarySalesScreen extends StatefulWidget {
  const SummarySalesScreen({super.key});

  @override
  State<SummarySalesScreen> createState() => _State();
}

class _State extends State<SummarySalesScreen> implements SalesSummaryView {
  late SalesSummaryPresenter presenter = SalesSummaryPresenter(this);

  final screenStateNotifier = ItemNotifier<_ScreenStates>(defaultValue: _ScreenStates.data);
  final salesItemDataNotifier = Notifier();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    presenter.loadSalesSummaryData();
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
              return SummarySalesLoader();

            //! ERROR STATE
            case _ScreenStates.error:
              return Scaffold(
                appBar: SummarySalesAppBarWidget(presenter),
                body: SummarySalesErrorView(
                  errorMessage: errorMessage,
                  onRetry: presenter.loadSalesSummaryData,
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
      appBar: SummarySalesAppBarWidget(presenter),
      body: RefreshIndicator(
        onRefresh: () => presenter.loadSalesSummaryData(),
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
                      maxHeight: 90 + 16,
                      child: Notifiable(
                        notifier: salesItemDataNotifier,
                        builder: (context) => LayoutBuilder(builder: (context, contraints) {
                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                            SummarySalesAppBarWidget.appbarNotifier.notify(contraints.maxHeight <= 90);
                          });
                          return Padding(
                            padding: contraints.maxHeight > 90 ? EdgeInsets.symmetric(horizontal: 24) : EdgeInsets.zero,
                            child: SummarySalesHeaderCard(presenter, contraints.maxHeight),
                          );
                        }),
                      ),
                    ),
                  ),
                  if (presenter.isSalesSummaryHasDetails)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: CategoriesView(presenter),
                      ),
                    )
                  else
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 150),
                        child: Text(
                          "There are no sales reports for\nthe selected filters",
                          textAlign: TextAlign.center,
                          style: TextStyles.titleTextStyle,
                        ),
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
  void showSalesSummaryFilter() async {
    var filters = await DateCustomRangeSelector.show(context, dateFilters: presenter.dateRangeFilters.copy());
    presenter.applyFilters(filters);
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
