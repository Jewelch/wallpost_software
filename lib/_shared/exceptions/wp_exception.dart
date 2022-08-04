import 'package:wallpost/_shared/analytics/error_reporter.dart';

abstract class WPException implements Exception {
  final String userReadableMessage;
  final String internalErrorMessage;

  WPException(this.userReadableMessage, this.internalErrorMessage) {
    ErrorReporter().reportError(this);
  }
}
