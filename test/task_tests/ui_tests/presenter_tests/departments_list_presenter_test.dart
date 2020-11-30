import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/_common_widgets/_list_view/error_list_tile.dart';
import 'package:wallpost/_common_widgets/_list_view/loader_list_tile.dart';
import 'package:wallpost/task/entities/department.dart';
import 'package:wallpost/task/services/departments_list_provider.dart';
import 'package:wallpost/task/ui/presenters/departments_list_presenter.dart';
import 'package:wallpost/task/ui/views/departments_list/departments_list_tile.dart';

import '../../../_mocks/mock_network_adapter.dart';

class MockDepartmentsListView extends Mock implements DepartmentsListView {}

class MockSelectedDepartmentsListView extends Mock
    implements SelectedDepartmentsListView {}

class MockDepartmentsListProvider extends Mock
    implements DepartmentsListProvider {}

class MockDepartment extends Mock implements Department {}

void main() {
  var view = MockDepartmentsListView();
  var selectedView = MockSelectedDepartmentsListView();
  var provider = MockDepartmentsListProvider();
  DepartmentsListPresenter presenter;

  setUp(() {
    presenter = DepartmentsListPresenter.initWith(view, selectedView, provider);
    reset(view);
    reset(provider);
    when(provider.isLoading).thenReturn(false);
    when(provider.didReachListEnd).thenReturn(false);
  });

  group('tests', () {
    test('shows loader on first load', () async {
      expect(presenter.getNumberOfItems(), 1);
      expect(presenter.getViewAtIndex(0) is LoaderListTile, true);
    });

    test('shows message when when there is no data', () async {
      when(provider.getNext()).thenAnswer((_) => Future.value([]));

      await presenter.loadNextListOfDepartments();
      when(provider.didReachListEnd).thenReturn(true);

      verify(view.reloadData()).called(1);
      expect(presenter.getNumberOfItems(), 1);
      expect(presenter.getViewAtIndex(0) is ErrorListTile, true);
      expect((presenter.getViewAtIndex(0) as ErrorListTile).message,
          'There are no departments to show. Tap here to reload.');
    });

    test(
        'successfully gets the first list of departments with more data available',
        () async {
      var dept1 = MockDepartment();
      var dept2 = MockDepartment();
      when(provider.getNext()).thenAnswer((_) => Future.value([dept1, dept2]));

      await presenter.loadNextListOfDepartments();

      verify(view.reloadData()).called(1);
      expect(presenter.getNumberOfItems(), 3);
      expect(presenter.getViewAtIndex(0) is DepartmentListTile, true);
      expect((presenter.getViewAtIndex(0) as DepartmentListTile).department,
          dept1);
      expect(presenter.getViewAtIndex(1) is DepartmentListTile, true);
      expect((presenter.getViewAtIndex(1) as DepartmentListTile).department,
          dept2);
      expect(presenter.getViewAtIndex(2) is LoaderListTile, true);
    });

    test('failed to get the first list of departments', () async {
      var errorToThrow = InvalidResponseException();
      when(provider.getNext()).thenThrow(errorToThrow);

      await presenter.loadNextListOfDepartments();

      verify(view.reloadData()).called(1);
      expect(presenter.getNumberOfItems(), 1);
      expect(presenter.getViewAtIndex(0) is ErrorListTile, true);
      expect((presenter.getViewAtIndex(0) as ErrorListTile).message,
          '${errorToThrow.userReadableMessage}\nTap here to reload.');
    });

    test('reloading data successfully after an error on first load', () async {
      when(provider.getNext()).thenThrow(InvalidResponseException());
      await presenter.loadNextListOfDepartments();

      when(provider.getNext()).thenAnswer(
          (_) => Future.value([MockDepartment(), MockDepartment()]));
      await presenter.loadNextListOfDepartments();

      expect(presenter.getNumberOfItems(), 3);
      expect(presenter.getViewAtIndex(0) is DepartmentListTile, true);
      expect(presenter.getViewAtIndex(1) is DepartmentListTile, true);
      expect(presenter.getViewAtIndex(2) is LoaderListTile, true);
    });

    test('shows a loader at the end of the list when more data is available',
        () async {
      var dept1 = MockDepartment();
      var dept2 = MockDepartment();
      when(provider.getNext()).thenAnswer((_) => Future.value([dept1, dept2]));
      await presenter.loadNextListOfDepartments();

      expect(presenter.getNumberOfItems(), 3);
      expect(presenter.getViewAtIndex(2) is LoaderListTile, true);
    });

    test(
        'does not show a loader at the end of the list when more data is not available',
        () async {
      var dept1 = MockDepartment();
      var dept2 = MockDepartment();
      when(provider.getNext()).thenAnswer((_) => Future.value([dept1, dept2]));
      await presenter.loadNextListOfDepartments();

      when(provider.didReachListEnd).thenReturn(true);
      await presenter.loadNextListOfDepartments();

      expect(presenter.getNumberOfItems(), 2);
      expect(presenter.getViewAtIndex(0) is DepartmentListTile, true);
      expect(presenter.getViewAtIndex(1) is DepartmentListTile, true);
    });

    test('shows error at the end of the list when failed to load more data',
        () async {
      var dept1 = MockDepartment();
      var dept2 = MockDepartment();
      when(provider.getNext()).thenAnswer((_) => Future.value([dept1, dept2]));
      await presenter.loadNextListOfDepartments();

      var errorToThrow = InvalidResponseException();
      when(provider.getNext()).thenThrow(errorToThrow);
      await presenter.loadNextListOfDepartments();

      expect(presenter.getNumberOfItems(), 3);
      expect(presenter.getViewAtIndex(0) is DepartmentListTile, true);
      expect(presenter.getViewAtIndex(1) is DepartmentListTile, true);
      expect(presenter.getViewAtIndex(2) is ErrorListTile, true);
    });

    test(
        'getting the next list of items when the provider is loading does nothing',
        () async {
      when(provider.isLoading).thenReturn(true);

      await presenter.loadNextListOfDepartments();

      verifyNever(provider.getNext());
      verifyNever(view.reloadData());
    });

    test(
        'getting the next list of items when there are no more forms does nothing',
        () async {
      when(provider.isLoading).thenReturn(false);
      when(provider.didReachListEnd).thenReturn(true);

      await presenter.loadNextListOfDepartments();

      verifyNever(view.reloadData());
    });

    test('resetting the presenter', () async {
      var dept1 = MockDepartment();
      var dept2 = MockDepartment();
      when(provider.getNext()).thenAnswer((_) => Future.value([dept1, dept2]));
      await presenter.loadNextListOfDepartments();

      reset(view);
      presenter.reset();

      verify(view.reloadData()).called(1);
      expect(presenter.getNumberOfItems(), 1);
      expect(presenter.getViewAtIndex(0) is LoaderListTile, true);
    });
  });
}
