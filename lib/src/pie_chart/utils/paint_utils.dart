import 'dart:math' show pi, Random, max, min;

import 'package:flutter/material.dart';
import './enums.dart';

class PaintUtils {
  static double calculateArcLength(double value) {
    return (2 * pi / 100.0) * value;
  }

  static void drawPieChart(
      Canvas canvas,
      Offset center,
      List<double> values,
      List<Color> sliceFillColors,
      double textSize,
      bool separateFocusedValue,
      SeparatedValue separatedValueType,
      double startAngle,
      bool randomStartAngle) {
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
  }

  static void drawLegend(
    Canvas canvas,
    Offset center,
    double legendIconSize,
    LegendIconShape legendIconShape,
    Color legendIconFillColor,
  ) {
    legendIconShape == LegendIconShape.Circle
        ? canvas.drawCircle(
            center,
            legendIconSize,
            getFillPaint(legendIconFillColor),
          )
        : canvas.drawRect(
            Rect.fromCenter(
              center: center,
              width: legendIconSize,
              height: legendIconSize,
            ),
            getFillPaint(legendIconFillColor));
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
