abstract class WPException implements Exception {
  final String userReadableMessage;
  final String internalErrorMessage;

  WPException(this.userReadableMessage, this.internalErrorMessage);
}
