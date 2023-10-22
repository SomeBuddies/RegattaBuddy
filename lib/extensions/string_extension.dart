import 'package:flutter/material.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() =>
      replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');

  Color toSeededColor() {
    const double saturation = 0.7;
    const double lightness = 0.6;

    final int hash = hashCode % 360;
    final double hue = hash.toDouble();
    return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
  }
}
