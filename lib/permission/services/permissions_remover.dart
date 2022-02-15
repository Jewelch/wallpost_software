import 'package:wallpost/permission/repositories/wp_actions_repository.dart';

class PermissionRemover {
  final WpActionsRepository _repository;

  PermissionRemover.initWith(this._repository);

  PermissionRemover() : _repository = WpActionsRepository();

  void removePermissions() {
    _repository.clearRequestItems();
  }
}
