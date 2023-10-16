import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:notifiable/notifiable.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:wallpost/_shared/date_range_selector/ui/widgets/date_range_selector.dart';

import '../../../../../../../_common_widgets/app_bars/sliver_app_bar_delegate.dart';
import '../../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../../_shared/constants/app_colors.dart';
import '../../presenter/orders_summary_presenter.dart';
import '../../view_contracts/orders_summary_view.dart';
import '../loader/orders_summary_loader.dart';
import '../widgets/orders_summary_list.dart';
import '../widgets/orders_summary_app_bar.dart';
import '../widgets/orders_summary_error_view.dart';
import '../widgets/orders_summary_header_card.dart';

enum _ScreenStates { loading, error, data }

class OrdersSummaryScreen extends StatefulWidget {
  const OrdersSummaryScreen({super.key});

  @override
  State<OrdersSummaryScreen> createState() => _State();
}

class _State extends State<OrdersSummaryScreen> implements OrdersSummaryView {
  late OrdersSummaryPresenter presenter = OrdersSummaryPresenter(this);
  final ScrollController controller = ScrollController();

  final screenStateNotifier = ItemNotifier<_ScreenStates>(defaultValue: _ScreenStates.data);
  final paginationNotifier = ItemNotifier<bool>(defaultValue: false);
  final totalNotifier = Notifier();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    presenter.loadNextOrdersSummary();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        presenter.loadNextOrdersSummary();
      }
    });
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
              return OrdersSummaryLoader();

            //! ERROR STATE
            case _ScreenStates.error:
              return Scaffold(
                appBar: OrdersSummaryAppBar(presenter),
                body: OrdersSummaryErrorView(
                  errorMessage: errorMessage,
                  onRetry: presenter.loadNextOrdersSummary,
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
      appBar: OrdersSummaryAppBar(presenter),
      body: RefreshIndicator(
        onRefresh: () => presenter.loadNextOrdersSummary(),
        child: Container(
          color: AppColors.screenBackgroundColor2,
          child: CustomScrollView(
            controller: controller,
            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              MultiSliver(
                children: [
                  SliverToBoxAdapter(child: SizedBox(height: 16)),
                  SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverAppBarDelegate(
                        minHeight: 56 + 16,
                        maxHeight: 120,
                        child: Notifiable(
                          notifier: totalNotifier,
                          builder: (context) => LayoutBuilder(builder: (context, contraints) {
                            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                              OrdersSummaryAppBar.appbarNotifier.notify(contraints.maxHeight <= 90);
                            });
                            return Padding(
                              padding:
                                  contraints.maxHeight > 90 ? EdgeInsets.symmetric(horizontal: 24) : EdgeInsets.zero,
                              child: OrdersSummaryHeaderCard(presenter, contraints.maxHeight),
                            );
                          }),
                        ),
                      )),
                  if (presenter.ordersSummary?.orders.isNotEmpty ?? false)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: OrdersSummaryList(presenter),
                      ),
                    )
                  else
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 150),
                        child: Text(
                          "There are no orders reports for\nthe selected filters",
                          textAlign: TextAlign.center,
                          style: TextStyles.titleTextStyle,
                        ),
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: ItemNotifiable<bool>(
                      notifier: paginationNotifier,
                      builder: ((context, value) => value
                          ? Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Center(
                                  child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                ),
                              )),
                            )
                          : SizedBox()),
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
    var filters = await DateRangeSelector.show(context, initialDateRange: presenter.filters);
    presenter.applyFilters(filters);
  }

  @override
  void onDidLoadReport() {
    screenStateNotifier.notify(_ScreenStates.data);
    paginationNotifier.notify(false);
  }

  @override
  void showErrorMessage(String msg) {
    this.errorMessage = msg;
    screenStateNotifier.notify(_ScreenStates.error);
    paginationNotifier.notify(false);
  }

  @override
  void showNoSummaryMessage() {
    screenStateNotifier.notify(_ScreenStates.data);
    paginationNotifier.notify(false);
  }

  @override
  showPaginationLoader() {
    paginationNotifier.notify(true);
  }
}
