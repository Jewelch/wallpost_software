import 'package:wallpost/_shared/local_storage/secure_shared_prefs.dart';
import 'package:wallpost/permission/entities/wp_action.dart';

class WpActionsRepository {
  late SecureSharedPrefs _sharedPrefs;
  final _key = "wp_actions";
  List<WPAction> _wpActions = [];

  WpActionsRepository() : _sharedPrefs = SecureSharedPrefs();

  WpActionsRepository.initWith(this._sharedPrefs);

  Future saveRequestItemsForEmployee(String companyId, List<WPAction> requestItems) async {
    this._wpActions = requestItems;
    var mappedRequestItem = requestItems.map((item) => item.toReadableString()).toList();
    Map itemsMap = {companyId: mappedRequestItem};
    _sharedPrefs.saveMap(_key, itemsMap);
  }

  Future<List<WPAction>> getActionsForEmployee(String companyId) async {
    if (_wpActions.isEmpty) {
      _wpActions = await _readWpActions(companyId);
    }
    return _wpActions;
  }

  Future<List<WPAction>> _readWpActions(String companyId) async {
    var itemsMap = await _sharedPrefs.getMap(_key);
    List mappedItems = itemsMap?[companyId] ?? [];
    var items = mappedItems.map<WPAction>((item) => initializeRequestFromString(item)!).toList();
    return items;
  }

  Future clearRequestItems() async {
    await _sharedPrefs.removeMap(_key);
  }
}
