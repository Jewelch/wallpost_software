import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/screen_presenter/modal_sheet_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/extensions/string_extensions.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_data.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/views/restaurant_dashboard_date_filter.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/views/restaurant_dashboard_header_card.dart';

import '../../../../_shared/constants/app_colors.dart';
import '../../entities/filtering_value.dart';
import '../view_contracts/sales_data_view.dart';

class RestaurantDashboardScreen extends StatefulWidget {
  @override
  State<RestaurantDashboardScreen> createState() => _State();
}

class _State extends State<RestaurantDashboardScreen> implements RestaurantDashboardView {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _modalSheetController = ModalSheetController();
  final _salesDataNotifier = ItemNotifier<SalesData>(defaultValue: SalesData.empty());
  String? _selectedFilteringValue;

  @override
  void dispose() {
    _modalSheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Spacer(),
                  InkWell(
                    onTap: showBottomFilter,
                    child: Text(
                      _selectedFilteringValue ?? "Today",
                      style: TextStyles.largeTitleTextStyleBold.copyWith(color: AppColors.defaultColor),
                    ),
                  ),
                  SizedBox(width: 5),
                  SvgPicture.asset(
                    'assets/icons/arrow_down_icon.svg',
                    color: AppColors.defaultColor,
                    width: 17,
                    height: 17,
                  ),
                ],
              ),
            ),
            ItemNotifiable<SalesData>(
              notifier: _salesDataNotifier,
              builder: (context, value) => RestaurantDashboardHeaderCard(value),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void showErrorMessage(String errorMessage) {}

  @override
  void showLoader() {}

  @override
  void showSalesData(SalesData salesData) => _salesDataNotifier.notify(salesData);

  @override
  void showBottomFilter() => ModalSheetPresenter.present(
        context: context,
        content: DateFilteringBottomSheet(
            elements: ['Today', 'Yesterday', 'This week', 'This month', 'This year', 'Last year'],
            onFilterSettled: (FilteringValue filteringValues) {
              setState(() => _selectedFilteringValue = filteringValues.filteringElement);
              print(filteringValues.filteringElement.toSnakeCase);
              print(filteringValues.startDate);
              print(filteringValues.endDate);
            }),
        controller: _modalSheetController,
      );
}
