import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:notifiable/notifiable.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../_shared/constants/app_colors.dart';
import '../../../../../restaurant_dashboard/ui/views/widgets/sliver_sales_breakdowns_horizontal_list.dart';
import '../../presenter/item_sales_presenter.dart';
import '../../view_contracts/item_sales_view.dart';
import '../loader/item_sales_loader.dart';
import '../widgets/item_sales_app_bar.dart';
import '../widgets/item_sales_error_view.dart';
import '../widgets/item_sales_header_card.dart';
import '../widgets/item_sales_wise.dart';
import '../widgets/restaurant_reports_filters.dart';
import '../widgets/share_reports_button.dart';

enum _ScreenStates { loading, error, data }

class ItemSalesScreen extends StatefulWidget {
  const ItemSalesScreen({super.key});

  @override
  State<ItemSalesScreen> createState() => _State();
}

class _State extends State<ItemSalesScreen> implements ItemSalesView {
  late ItemSalesPresenter presenter = ItemSalesPresenter(this);

  final screenStateNotifier = ItemNotifier<_ScreenStates>(defaultValue: _ScreenStates.data);
  final salesItemDataNotifier = Notifier();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    presenter.loadItemSalesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ItemNotifiable<_ScreenStates>(
        notifier: screenStateNotifier,
        builder: (_, currentState) {
          switch (currentState) {
            // $ LOADING STATE
            case _ScreenStates.loading:
              return ItemSalesLoader();

            //! ERROR STATE
            case _ScreenStates.error:
              return SalesItemErrorView(
                errorMessage: errorMessage,
                onRetry: presenter.loadItemSalesData,
              );

            // //* DATA STATE
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
      body: Container(
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
                    maxHeight: 166,
                    child: Notifiable(
                      notifier: salesItemDataNotifier,
                      builder: (context) => LayoutBuilder(builder: (context, contraints) {
                        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                          AppBarWidget.appbarNotifier.notify(contraints.maxHeight <= 100);
                        });
                        return Padding(
                          padding: contraints.maxHeight > 100 ? EdgeInsets.symmetric(horizontal: 24) : EdgeInsets.zero,
                          child: ItemSalesHeaderCard(presenter, contraints.maxHeight),
                        );
                      }),
                    ),
                  ),
                ),
                if (presenter.getDataListLength() != 0)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: ItemSalesWise(presenter),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ShareReportButton(presenter),
    );
  }

  @override
  void showLoader() => screenStateNotifier.notify(_ScreenStates.loading);

  @override
  void showSalesReportFilter() async {
    var newFilters = await RestaurantReportsFilters.show(
      context,
      initialFilters: presenter.filters.copy(),
    );
    presenter.applyFilters(newFilters);
  }

  @override
  void onDidChangeFilters() {
    setState(() {});
  }

  @override
  void showItemSalesBreakDowns() {
    screenStateNotifier.notify(_ScreenStates.data);
  }

  @override
  void showErrorMessage(String message) {
    this.errorMessage = errorMessage;
    screenStateNotifier.notify(_ScreenStates.error);
  }

  @override
  void updateItemSalesData() => screenStateNotifier.notify(_ScreenStates.data);

  @override
  void showNoItemSalesBreakdownMessage() {
    screenStateNotifier.notify(_ScreenStates.data);
  }
}
