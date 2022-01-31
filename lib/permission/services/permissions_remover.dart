import 'package:wallpost/permission/repositories/request_items_repository.dart';

class PermissionRemover {
  final RequestItemsRepository _repository;

  PermissionRemover.initWith(this._repository);

  PermissionRemover() : _repository = RequestItemsRepository();

  void removePermissions() {
    _repository.clearRequestItems();
  }
}
