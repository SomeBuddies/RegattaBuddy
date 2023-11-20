import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

extension ExceptionLoggerExtension on Exception {
  void log(Logger logger) {
    logger.e(toString());
  }

  void showErrorSnackbar(BuildContext context, String? message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? toString())),
    );
  }
}
