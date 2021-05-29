import 'dart:math' show pi, Random, cos;

import 'package:flutter/material.dart';

/// This provides utility methods common to different chart types
class CommonPaintUtils {
  static const double LABEL_X_PADDING = 7.0;
  static const double LABEL_Y_PADDING = 7.0;

  /// Returns the Fill Paint object for the graph.
  static Paint getFillPaint(Color fillColor, {int? alpha}) {
    return Paint()
      ..color = fillColor.withAlpha(alpha ?? 255)
      ..style = PaintingStyle.fill;
  }

  /// Calculates the text size for the labels based on canvas size and [textScaleFactor]
  static double getTextSize(Size size, double textScaleFactor) {
    return (size.height + size.width) / 2 * textScaleFactor;
  }

  ///Returns the Stroke Paint object for the graph.
  static Paint getStrokePaint(
    Color strokeColor,
    int alpha,
    double strokeWidth,
  ) {
    return Paint()
      ..color = strokeColor.withAlpha(alpha)
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
  }

  /// Calculates the default width of the label's text, if [labelWidth] is null.
  static double getDefaultLabelWidth(Size size, Offset center, double angle) {
    return (size.width -
            (center.dy / 2) * cos(angle - pi / 2) -
            CommonPaintUtils.LABEL_X_PADDING) /
        2.85;
  }

  /// Calculates the default maximum number of lines for label's text,
  /// if [maxLinesForLabels] is null.
  static int getDefaultMaxLinesForLabels(Size size) {
    return (size.height / 100).ceil();
  }

  /// returns random colors list having size equal to the provided length variable
  static List<Color> getRandomColors(int length) {
    return List.generate(
        length,
        (int index) => Color.fromARGB(255, Random().nextInt(200),
            Random().nextInt(200), Random().nextInt(200)));
  }

  /// calculates and returns the arc length
  static double calculateArcLength(double value) {
    return (2 * pi / 100.0) * value;
  }
}
