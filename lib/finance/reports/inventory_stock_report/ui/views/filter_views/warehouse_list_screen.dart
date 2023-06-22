import 'package:flutter/material.dart' hide SearchBar;
import 'package:wallpost/_common_widgets/screen_presenter/center_sheet_presenter.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/entities/inventory_stock_warehouse.dart';

import '../../../../../../_common_widgets/search_bar/search_bar.dart';
import '../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../_shared/constants/app_colors.dart';
import '../../../services/inventory_warehouse_list_provider.dart';

class WarehouseListScreen extends StatefulWidget {
  final CenterSheetController _centerSheetController;

  const WarehouseListScreen._(this._centerSheetController, {Key? key}) : super(key: key);

  static Future<dynamic> show({required BuildContext context}) {
    var centerSheetController = CenterSheetController();
    return CenterSheetPresenter.present(
      context: context,
      controller: centerSheetController,
      content: WarehouseListScreen._(centerSheetController),
    );
  }

  @override
  State<WarehouseListScreen> createState() => _WarehouseListScreenState();
}

class _WarehouseListScreenState extends State<WarehouseListScreen> implements WarehouseListView {
  late WarehouseListPresenter _presenter;

  @override
  void initState() {
    _presenter = WarehouseListPresenter(this);
    _presenter.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_presenter.isLoading) {
      return Container(
        height: 500,
        child: Column(
          children: [
            _topBar(),
            Expanded(
              child: GestureDetector(
                onTap: () => _presenter.loadData(),
                child: Container(
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_presenter.errorMessage != null) {
      return Container(
        height: 500,
        child: Column(
          children: [
            _topBar(),
            Expanded(
              child: GestureDetector(
                onTap: () => _presenter.loadData(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Center(child: Text(_presenter.errorMessage!)),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      height: 500,
      child: Column(
        children: [
          _topBar(),
          SearchBar(
            hint: "Search",
            autoFocus: false,
            onSearchTextChanged: (searchText) {},
          ),
          Expanded(
            child: Container(
              child: ListView.separated(
                itemCount: _presenter.getNumberOfWarehouses(),
                padding: EdgeInsets.symmetric(vertical: 20),
                itemBuilder: (context, index) {
                  return Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () => _presenter.selectWarehouseAtIndex(index),
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _presenter.getWarehouseNameAtIndex(index),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, index) {
                  if (index == _presenter.getNumberOfWarehouses() - 1) {
                    return Container();
                  } else {
                    return Divider(height: 1);
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Container(
      height: 60,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 6),
            TextButton(
              onPressed: () => widget._centerSheetController.close(),
              child: Text(
                "Cancel",
                style: TextStyles.titleTextStyle.copyWith(
                  color: AppColors.defaultColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "Select Warehouse",
                  style: TextStyles.titleTextStyle,
                ),
              ),
            ),
            SizedBox(width: 70),
          ],
        ),
      ),
    );
  }

  //MARK: View functions
  @override
  void showLoader() {
    setState(() {});
  }

  @override
  void onDidFailToLoadWarehouses() {
    setState(() {});
  }

  @override
  void onDidLoadWarehousesSuccessfully() {
    setState(() {});
  }

  @override
  void onDidSelectWarehouse(result) {
    widget._centerSheetController.close(result: result);
  }
}

abstract class WarehouseListView {
  void showLoader();

  void onDidFailToLoadWarehouses();

  void onDidLoadWarehousesSuccessfully();

  void onDidSelectWarehouse(dynamic result);
}

class WarehouseListPresenter {
  final WarehouseListView _view;
  final InventoryWarehouseListProvider _warehouseListProvider;
  List<InventoryStockWarehouse> _warehouses = [];
  String? _errorMessage;

  WarehouseListPresenter(this._view) : _warehouseListProvider = InventoryWarehouseListProvider();

  WarehouseListPresenter.initWith(this._view, this._warehouseListProvider);

  Future<void> loadData() async {
    if (_warehouseListProvider.isLoading) return;

    _view.showLoader();
    _errorMessage = null;

    try {
      _warehouses = await _warehouseListProvider.getAll();
      _view.onDidLoadWarehousesSuccessfully();
    } on WPException catch (e) {
      _errorMessage = "${e.userReadableMessage}\n\nTap here to reload.";
      _view.onDidFailToLoadWarehouses();
    }
  }

  int getNumberOfWarehouses() {
    if (_warehouses.length == 0) return 0;

    return _warehouses.length + 1;
  }

  String getWarehouseNameAtIndex(int index) {
    if (index == 0)
      return "All";
    else
      return _warehouses[index - 1].name;
  }

  void selectWarehouseAtIndex(int index) {
    if (index == 0)
      _view.onDidSelectWarehouse("all");
    else
      _view.onDidSelectWarehouse(_warehouses[index - 1]);
  }

  bool get isLoading => _warehouseListProvider.isLoading;

  String? get errorMessage => _errorMessage;
}
