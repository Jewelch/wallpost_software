import 'package:wallpost/_shared/local_storage/secure_shared_prefs.dart';
import 'package:wallpost/permission/entities/wp_action.dart';

class RequestItemsRepository {
  late SecureSharedPrefs _sharedPrefs;
  final _key = "request_items";
  List<WPAction> requestItems = [];

  RequestItemsRepository() : _sharedPrefs = SecureSharedPrefs();

  RequestItemsRepository.initWith(this._sharedPrefs);

  Future saveRequestItemsForEmployee(String companyId, List<WPAction> requestItems) async {
    this.requestItems = requestItems;
    var mappedRequestItem = requestItems.map((item) => item.toReadableString()).toList();
    Map itemsMap = {companyId: mappedRequestItem};
    _sharedPrefs.saveMap(_key, itemsMap);
  }

  Future<List<WPAction>> getRequestItemsOfCompany(String companyId) async {
    if (requestItems.isEmpty) {
      requestItems = await _readRequestItems(companyId);
    }
    return requestItems;
  }

  Future<List<WPAction>> _readRequestItems(String companyId) async {
    var itemsMap = await _sharedPrefs.getMap(_key);
    List mappedItems = itemsMap?[companyId] ?? [];
    var items = mappedItems.map<WPAction>((item) => initializeRequestFromString(item)!).toList();
    return items;
  }

  Future clearRequestItems() async {
    await _sharedPrefs.removeMap(_key);
  }
}
