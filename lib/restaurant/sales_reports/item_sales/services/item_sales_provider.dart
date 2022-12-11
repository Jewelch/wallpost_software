import 'dart:async';

import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/constants/items_sales_urls.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/entities/sales_as_category_model.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/entities/sales_as_item_model.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/entities/sales_item_view_options.dart';

import '../../../../_wp_core/company_management/services/selected_company_provider.dart';

final responsesList = [
  itemWiseResponse,
  categoryWiseResponse,
  categoryItemWiseResponse,
];

class ItemSalesProvider {
  final NetworkAdapter _networkAdapter;
  final SelectedCompanyProvider _selectedCompanyProvider;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;

  ItemSalesProvider()
      : _networkAdapter = WPAPI(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  ItemSalesProvider.initWith(this._networkAdapter, this._selectedCompanyProvider);

  Future<Object> getItemSales(DateRangeFilters dateRangeFilters, SalesItemWiseOptions salesItemOptions) async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url = ItemSalesUrls.getSalesItemUrl(
      salesItemOptions,
      companyId,
      "0",
      dateRangeFilters,
    );
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);

    _isLoading = true;
    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      _isLoading = false;
      return _processResponse(apiResponse, salesItemOptions);
    } on APIException catch (exception) {
      _isLoading = false;
      throw exception;
    }
  }

  Future<Object> _processResponse(APIResponse apiResponse, SalesItemWiseOptions salesItemOptions) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<SalesAsCategoriesModel>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! List<Map<String, dynamic>>) throw WrongResponseFormatException();

    var responseList = apiResponse.data as List<Map<String, dynamic>>;
    try {
      switch (salesItemOptions) {
        case SalesItemWiseOptions.viewAsCategoryAndItem:
          var salesItemAsCategoryList = <SalesAsCategoriesModel>[];
          responseList.forEach((element) {
            salesItemAsCategoryList.add(SalesAsCategoriesModel.fromJson(element));
          });

          return salesItemAsCategoryList;

        case SalesItemWiseOptions.viewAsItem:
          var salesItemAsItemList = <SalesAsItemModel>[];
          responseList.forEach((element) => salesItemAsItemList.add(SalesAsItemModel.fromJson(element)));

          return salesItemAsItemList;

        case SalesItemWiseOptions.viewAsCategory:
          var salesItemAsCategoryList = <SalesAsCategoriesModel>[];
          responseList.forEach((element) {
            salesItemAsCategoryList.add(SalesAsCategoriesModel.fromJson(element));
          });
          return salesItemAsCategoryList;

        default:
          var salesItemAsCategoryList = <SalesAsCategoriesModel>[];

          return salesItemAsCategoryList;
      }
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  bool get isLoading => _isLoading;
}

final itemWiseResponse = {
  "status": "success",
  "metadata": [],
  "data": [
    {"itemId": 7, "item_name": "Stewart's", "qty": 2, "revenue": 12},
    {"itemId": 6, "item_name": "Mirinda", "qty": 4, "revenue": 20},
    {"itemId": 5, "item_name": "Fanta", "qty": 2, "revenue": 8},
    {"itemId": 1, "item_name": "Coke", "qty": 2, "revenue": 11},
    {"itemId": 8, "item_name": "Mtn Dew Live Wire", "qty": 2, "revenue": 14},
    {"itemId": 2, "item_name": "Cesar Salad with chicken ", "qty": 3, "revenue": 33},
    {"itemId": 11, "item_name": "Pasta Salad", "qty": 3, "revenue": 53.94},
    {"itemId": 12, "item_name": "Creamy Vegan Pasta Salad", "qty": 2, "revenue": 56}
  ]
};

Map<String, dynamic> categoryWiseResponse = {
  "status": "success",
  "metadata": [],
  "data": [
    {
      "categoryId": 1,
      "categoryName": "Drinks",
      "totalQuantity": 12,
      "totalRevenue": 65,
    },
    {
      "categoryId": 2,
      "categoryName": "Salads",
      "totalQuantity": 8,
      "totalRevenue": 142.94,
    }
  ]
};

final categoryItemWiseResponse = {
  "status": "success",
  "metadata": [],
  "data": [
    {"totalRevenue": 207.94, "totalQuantity": 20},
    [
      {
        "categoryId": 1,
        "categoryName": "Drinks",
        "items": [
          {"itemId": 7, "item_name": "Stewart's", "qty": 2, "revenue": 12},
          {"itemId": 6, "item_name": "Mirinda", "qty": 4, "revenue": 20},
          {"itemId": 5, "item_name": "Fanta", "qty": 2, "revenue": 8},
          {"itemId": 1, "item_name": "Coke", "qty": 2, "revenue": 11},
          {"itemId": 8, "item_name": "Mtn Dew Live Wire", "qty": 2, "revenue": 14}
        ],
        "totalQuantity": 12,
        "totalRevenue": 65
      },
      {
        "categoryId": 2,
        "categoryName": "Salads",
        "items": [
          {"itemId": 2, "item_name": "Cesar Salad with chicken ", "qty": 3, "revenue": 33},
          {"itemId": 11, "item_name": "Pasta Salad", "qty": 3, "revenue": 53.94},
          {"itemId": 12, "item_name": "Creamy Vegan Pasta Salad", "qty": 2, "revenue": 56}
        ],
        "totalQuantity": 8,
        "totalRevenue": 142.94
      }
    ]
  ]
};
