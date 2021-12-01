import 'package:flutter/foundation.dart';

abstract class Logger {

  static void message(String message) {
    if (kDebugMode) {
      print('\x1B[34m$message\x1B[0m');
    }
  }

  static void error(String message) {
    if (kDebugMode) {
      print('\x1B[31m$message\x1B[0m');
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      print('\x1B[33m$message\x1B[0m');
    }
  }
}