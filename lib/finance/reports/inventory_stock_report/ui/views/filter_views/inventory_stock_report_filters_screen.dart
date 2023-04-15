import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/screen_presenter/modal_sheet_presenter.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/entities/inventory_stock_warehouse.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/ui/views/filter_views/warehouse_list_screen.dart';

import '../../../../../../_common_widgets/filter_views/filters_modal_sheet/filters_modal_sheet.dart';
import '../../../../../../_common_widgets/filter_views/filters_modal_sheet/modal_sheet_detail_disclosure_filter.dart';
import '../../../../../../_common_widgets/filter_views/filters_modal_sheet/modal_sheet_radio_group_filter.dart';
import '../../../../../../_common_widgets/filter_views/radio_group.dart';
import '../../../../../../_shared/date_range_selector/ui/widgets/single_date_selector.dart';
import '../../../entities/inventory_stock_report_filter.dart';
import '../../presenters/inventory_stock_report_presenter.dart';

class InventoryStockReportFiltersScreen extends StatefulWidget {
  final InventoryStockReportPresenter _presenter;
  final ModalSheetController modalSheetController;

  const InventoryStockReportFiltersScreen._(
    this._presenter,
    this.modalSheetController, {
    Key? key,
  }) : super(key: key);

  static Future<dynamic> show({
    required BuildContext context,
    required InventoryStockReportPresenter presenter,
  }) {
    var modalSheetController = ModalSheetController();
    return ModalSheetPresenter.present(
      context: context,
      content: InventoryStockReportFiltersScreen._(presenter, modalSheetController),
      controller: modalSheetController,
    );
  }

  @override
  State<InventoryStockReportFiltersScreen> createState() => _InventoryStockReportFiltersScreenState();
}

class _InventoryStockReportFiltersScreenState extends State<InventoryStockReportFiltersScreen> {
  late InventoryStockReportFilter newFilters;

  @override
  void initState() {
    newFilters = widget._presenter.copyOfCurrentFilters;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FiltersListView(
      filters: [
        ModalSheetDetailDisclosureFilter(
          filterTitle: "Date",
          itemTitle: newFilters.getDateFilterTitle(),
          onPressed: () => _launchDateSelection(),
        ),
        ModalSheetDetailDisclosureFilter(
          filterTitle: "Warehouse",
          itemTitle: newFilters.getWarehouseFilterTitle(),
          onPressed: () => _launchWarehouseSelection(),
        ),
        ModalSheetRadioGroupFilter(
          filterTitle: "Sort By",
          radioGroup: RadioGroup(
            items: [
              "Price: Lowest",
              "Price: Highest",
              "Quantity: Lowest First",
              "Quantity: Highest First",
            ],
            selectedIndex: null,
            onDidSelectRadioItemAtIndex: (index) {},
          ),
        )
      ],
      onCancelButtonPressed: () => widget.modalSheetController.close(),
      onResetButtonPressed: () {
        newFilters = widget._presenter.copyOfCurrentFilters;
        setState(() {});
      },
      onApplyChangesButtonPressed: () {
        widget._presenter.updateFilters(newFilters);
        widget.modalSheetController.close();
      },
    );
  }

  Future<void> _launchDateSelection() async {
    var selectedDate = await SingleDateSelector.show(
      context,
      initialDate: newFilters.date,
      maxDate: DateTime.now(),
    );
    if (selectedDate != null) {
      newFilters.date = selectedDate;
      setState(() {});
    }
  }

  Future<void> _launchWarehouseSelection() async {
    var warehouse = await WarehouseListScreen.show(context: context);

    if (warehouse == "all") {
      newFilters.warehouse = null;
      setState(() {});
    } else if (warehouse is InventoryStockWarehouse) {
      newFilters.warehouse = warehouse;
      setState(() {});
    }
  }
}
