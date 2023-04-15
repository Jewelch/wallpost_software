import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/entities/inventory_stock_warehouse.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/services/inventory_warehouse_list_provider.dart';
import 'package:wallpost/finance/reports/inventory_stock_report/ui/views/filter_views/warehouse_list_screen.dart';

class MockWarehouse extends Mock implements InventoryStockWarehouse {}

class MockWarehouseListView extends Mock implements WarehouseListView {}

class MockWarehouseListProvider extends Mock implements InventoryWarehouseListProvider {}

void main() {
  late MockWarehouseListView view;
  late MockWarehouseListProvider warehouseListProvider;
  late WarehouseListPresenter presenter;

  setUp(() {
    view = MockWarehouseListView();
    warehouseListProvider = MockWarehouseListProvider();
    presenter = WarehouseListPresenter.initWith(view, warehouseListProvider);
  });

  void verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(warehouseListProvider);
  }

  test("does nothing when the provider is loading", () async {
    //given
    when(() => warehouseListProvider.isLoading).thenReturn(true);

    //when
    await presenter.loadData();

    //then
    verifyInOrder([
      () => warehouseListProvider.isLoading,
    ]);
    verifyNoMoreInteractionsOnAllMocks();
  });

  test("failure to load warehouses", () async {
    //given
    when(() => warehouseListProvider.isLoading).thenReturn(false);
    when(() => warehouseListProvider.getAll()).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadData();

    //then
    expect(presenter.errorMessage, "${InvalidResponseException().userReadableMessage}\n\nTap here to reload.");
    verifyInOrder([
      () => warehouseListProvider.isLoading,
      () => view.showLoader(),
      () => warehouseListProvider.getAll(),
      () => view.onDidFailToLoadWarehouses(),
    ]);
    verifyNoMoreInteractionsOnAllMocks();
  });

  test("successfully loading warehouses", () async {
    //given
    when(() => warehouseListProvider.isLoading).thenReturn(false);
    when(() => warehouseListProvider.getAll()).thenAnswer((_) => Future.value([
          MockWarehouse(),
          MockWarehouse(),
          MockWarehouse(),
        ]));

    //when
    await presenter.loadData();

    //then
    verifyInOrder([
      () => warehouseListProvider.isLoading,
      () => view.showLoader(),
      () => warehouseListProvider.getAll(),
      () => view.onDidLoadWarehousesSuccessfully(),
    ]);
    verifyNoMoreInteractionsOnAllMocks();
  });

  test("number of list items is 0 if there are no warehouses", () async {
    //given
    when(() => warehouseListProvider.isLoading).thenReturn(false);
    when(() => warehouseListProvider.getAll()).thenAnswer((_) => Future.value([]));
    await presenter.loadData();

    //then
    expect(presenter.getNumberOfWarehouses(), 0);
  });

  test("number of list items when there are warehouses", () async {
    //given
    var warehouse1 = MockWarehouse();
    var warehouse2 = MockWarehouse();
    var warehouse3 = MockWarehouse();
    when(() => warehouse1.name).thenReturn("name 1");
    when(() => warehouse2.name).thenReturn("name 2");
    when(() => warehouse3.name).thenReturn("name 3");
    when(() => warehouseListProvider.isLoading).thenReturn(false);
    when(() => warehouseListProvider.getAll()).thenAnswer(
      (_) => Future.value([
        warehouse1,
        warehouse2,
        warehouse3,
      ]),
    );
    await presenter.loadData();

    //then
    expect(presenter.getNumberOfWarehouses(), 4);
    expect(presenter.getWarehouseNameAtIndex(0), "All");
    expect(presenter.getWarehouseNameAtIndex(1), "name 1");
    expect(presenter.getWarehouseNameAtIndex(2), "name 2");
    expect(presenter.getWarehouseNameAtIndex(3), "name 3");
  });

  test("selecting warehouse at index", () async {
    //given
    var warehouse1 = MockWarehouse();
    var warehouse2 = MockWarehouse();
    var warehouse3 = MockWarehouse();
    when(() => warehouseListProvider.isLoading).thenReturn(false);
    when(() => warehouseListProvider.getAll()).thenAnswer(
      (_) => Future.value([
        warehouse1,
        warehouse2,
        warehouse3,
      ]),
    );
    await presenter.loadData();

    presenter.selectWarehouseAtIndex(0);
    verify(() => view.onDidSelectWarehouse("all"));

    presenter.selectWarehouseAtIndex(1);
    verify(() => view.onDidSelectWarehouse(warehouse1));

    presenter.selectWarehouseAtIndex(2);
    verify(() => view.onDidSelectWarehouse(warehouse2));

    presenter.selectWarehouseAtIndex(3);
    verify(() => view.onDidSelectWarehouse(warehouse3));
  });
}
