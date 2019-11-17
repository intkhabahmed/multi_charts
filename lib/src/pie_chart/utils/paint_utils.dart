import 'dart:math' show Random, cos, max, min, pi, sin;

import 'package:flutter/material.dart';

import 'legend_icon_shape.dart';
import 'legend_position.dart';
import 'separated_value.dart';

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
      LegendPosition legendPosition) {
    double calculatedStartAngle = (startAngle * (pi / 180));
    values.asMap().forEach((index, chartValue) {
      var length = legendPosition == LegendPosition.Bottom ||
              legendPosition == LegendPosition.Top
          ? center.dy
          : center.dx;
      if (separateFocusedValue &&
          values.reduce(separatedValueType == SeparatedValue.Max ? max : min) ==
              chartValue) {
        double cStartAngle = calculatedStartAngle + (pi * 0.01);
        double cSliceAngle = calculateArcLength(chartValue) - (pi * 0.01) * 2;
        canvas.save();
        var posX = 4 * cos(cStartAngle + cSliceAngle / 2);
        var posY = 4 * sin(cStartAngle + cSliceAngle / 2);
        canvas.translate(posX, posY);
        canvas.drawArc(
            Rect.fromCenter(
              center: center,
              width: length * 2 - 15,
              height: length * 2 - 15,
            ),
            cStartAngle,
            cSliceAngle,
            true,
            getFillPaint(sliceFillColors[index]));
        canvas.restore();
      } else {
        drawArc(
            canvas,
            Rect.fromCenter(
              center: center,
              width: length * 2 - 25,
              height: length * 2 - 25,
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
