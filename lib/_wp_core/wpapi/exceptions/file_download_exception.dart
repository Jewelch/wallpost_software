import 'api_exception.dart';

class FileDownloadException extends APIException {
  static const String _USER_READABLE_MESSAGE = "Oops! Looks like something has gone wrong. Please try again.";

  FileDownloadException(String errorMessage) : super(_USER_READABLE_MESSAGE, errorMessage, responseData: {});
}
