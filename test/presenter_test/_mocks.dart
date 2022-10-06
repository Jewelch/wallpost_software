import 'package:mocktail/mocktail.dart';

class SalesDataProvider {
  bool isLoading = false;

  getSalesData({String? storeId}) {}
}

class MockSalesDataProvider extends Mock implements SalesDataProvider {
}
