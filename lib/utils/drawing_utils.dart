
import 'dart:ui';

import 'package:flutter/cupertino.dart';

Color getColorForString(String stringValue) {
  final int hashCode = stringValue.hashCode % 360;
  final double hue = hashCode.toDouble();
  const double saturation = 0.7;
  const double lightness = 0.6;
  return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
}
