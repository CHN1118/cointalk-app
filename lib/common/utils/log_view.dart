import 'package:logger/logger.dart';

class LogView{
  static Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
    ),
  );

  static Logger loggerDetail = Logger(
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

  static Logger loggerFormat = Logger(
    printer:LogfmtPrinter(),
  );
}