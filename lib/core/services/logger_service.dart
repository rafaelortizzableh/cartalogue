import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final loggerServiceProvider = Provider<LoggerService>(
  (ref) => DebugLoggerService(),
);

abstract class LoggerService {
  void captureMessage(String message, {String? tag});
  void captureException(
    Object exception, {
    StackTrace? stackTrace,
    String? tag,
  });
}

class DebugLoggerService implements LoggerService {
  @override
  void captureException(
    Object exception, {
    StackTrace? stackTrace,
    String? tag,
  }) {
    log('EXCEPTION on [$tag]: $exception. StackTrace: $stackTrace');
  }

  @override
  void captureMessage(
    String message, {
    String? tag,
  }) {
    log('MESSAGE on [$tag]: $message');
  }
}
