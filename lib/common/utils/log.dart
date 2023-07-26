// ignore_for_file: non_constant_identifier_names

import 'package:logger/logger.dart';

class Log {
  static Logger log = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
    ),
  );

  static Logger logDetail = Logger(
    printer: PrettyPrinter(
      methodCount: 3,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
      noBoxingByDefault: false,
    ),
  );

  static Logger logFormat = Logger(
    printer: LogfmtPrinter(),
  );
}

Logger LLogger = Logger();
