import 'package:wallpost/_wp_core/wpapi/services/network_file_uploader.dart';

class ExpenseRequestExecutor {
  NetworkFileUploader _fileUploader;

  ExpenseRequestExecutor() : _fileUploader = NetworkFileUploader();

  ExpenseRequestExecutor.initWith(this._fileUploader);


}
