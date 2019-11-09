import 'dart:math' show pi, Random, max, min;

import 'package:flutter/material.dart';
import './enums.dart';

class PaintUtils {
  static double calculateArcLength(double value) {
    return (2 * pi / 100.0) * value;
  }

  static List<Color> drawPieChart(
      Canvas canvas,
      Offset center,
      List<double> values,
      List<Color> sliceFillColors,
      double textScaleFactor,
      bool separateFocusedValue,
      SeparatedValue separatedValueType,
      double startAngle,
      bool randomStartAngle) {
    if (sliceFillColors == null ||
        (sliceFillColors != null && sliceFillColors.isEmpty)) {
      sliceFillColors = getRandomColors(values.length);
    }
    double calculatedStartAngle =
        (randomStartAngle ? Random().nextDouble() : 1) *
            (startAngle * (pi / 180));
    values.asMap().forEach((index, chartValue) {
      if (separateFocusedValue &&
          values.reduce(separatedValueType == SeparatedValue.Max ? max : min) ==
              chartValue) {
        canvas.drawArc(
            Rect.fromCenter(
              center: center,
              width: center.dx * 2 - 5,
              height: center.dx * 2 - 5,
            ),
            calculatedStartAngle + (pi * 0.01),
            calculateArcLength(chartValue) - (pi * 0.01) * 2,
            true,
            getFillPaint(sliceFillColors[index]));
      } else {
        drawArc(
            canvas,
            Rect.fromCenter(
              center: center,
              width: center.dx * 2 - 20,
              height: center.dx * 2 - 20,
            ),
            calculatedStartAngle,
            chartValue,
            getFillPaint(sliceFillColors[index]));
      }
      calculatedStartAngle =
          calculatedStartAngle + calculateArcLength(chartValue);
    });
    canvas.drawCircle(center, 2.0, getFillPaint(Colors.black));
    return sliceFillColors;
  }

  static void drawLegend(
    Canvas canvas,
    List<String> labels,
    Color labelColor,
    Offset labelRegion,
    List<Color> sliceFillColors,
    double textSize,
    LabelIconShape iconShape,
  ) {
    
  }

  static void drawArc(
    Canvas canvas,
    Rect chartRect,
    double calculatedStartAngle,
    double chartValue,
    Paint chartPaint,
  ) {
    canvas.drawArc(chartRect, calculatedStartAngle,
        calculateArcLength(chartValue), true, chartPaint);
  }

  /// Returns the Fill Paint object for the graph.
  static Paint getFillPaint(Color fillColor) {
    return Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
  }

  ///Returns the Stroke Paint object for the graph.
  static Paint getStrokePaint(
      Color strokeColor, int alpha, double strokeWidth) {
    return Paint()
      ..color = Color.fromARGB(
          alpha, strokeColor.red, strokeColor.green, strokeColor.blue)
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
  }

  /// Calculates the text size for the labels based on canvas size and [RadarChart.textScaleFactor]
  static double getTextSize(Size size, double textScaleFactor) {
    return (size.height + size.width) / 2 * textScaleFactor;
  }

  static List<Color> getRandomColors(int length) {
    return List.generate(
        length,
        (int index) => Color.fromARGB(255, Random().nextInt(200),
            Random().nextInt(200), Random().nextInt(200)));
  }
}
