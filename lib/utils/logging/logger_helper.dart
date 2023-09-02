import 'package:logger/logger.dart';
import 'package:regatta_buddy/utils/logging/rb_log_printer.dart';

Logger getLogger(String className) {
  return Logger(printer: RBLogPrinter(className));
}
