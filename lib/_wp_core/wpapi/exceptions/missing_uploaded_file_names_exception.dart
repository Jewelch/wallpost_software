import 'api_exception.dart';

class MissingUploadedFileNamesException extends APIException {
  static const _USER_READABLE_MESSAGE = "Oops! Looks like something has gone wrong. Please try again.";
  static const _INTERNAL_MESSAGE = "File upload did not return any file names";

  MissingUploadedFileNamesException() : super(_USER_READABLE_MESSAGE, _INTERNAL_MESSAGE);
}
