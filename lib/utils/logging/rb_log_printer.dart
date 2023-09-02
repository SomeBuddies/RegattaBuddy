import 'package:logger/logger.dart';

class RBLogPrinter extends LogPrinter {
  final String className;
  RBLogPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.defaultLevelColors[event.level];
    final emoji = PrettyPrinter.defaultLevelEmojis[event.level];
    final message = color!('$emoji $className - ${event.message}');
    return [message];
  }
}
