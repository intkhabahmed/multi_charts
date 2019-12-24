import 'dart:math' show Random, cos, max, min, pi, sin;

import 'package:flutter/material.dart';

import 'legend_icon_shape.dart';
import 'legend_position.dart';
import 'separated_value.dart';

class PaintUtils {
  static const double LABEL_X_PADDING = 7.0;
  static const double LABEL_Y_PADDING = 7.0;

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
      LegendPosition legendPosition,
      bool isAnimationOver,
      Color labelColor) {
    double calculatedStartAngle = startAngle * (pi / 180);
    values.asMap().forEach((index, chartValue) {
      var length = legendPosition == LegendPosition.Bottom ||
              legendPosition == LegendPosition.Top
          ? center.dy
          : center.dx;
      if (separateFocusedValue &&
          values.reduce(separatedValueType == SeparatedValue.Max ? max : min) ==
              chartValue) {
        double cStartAngle = calculatedStartAngle;
        double cSliceAngle = calculateArcLength(chartValue);
        canvas.save();
        var posX = getXPosition(5, cStartAngle + cSliceAngle / 2);
        var posY = getYPosition(5, cStartAngle + cSliceAngle / 2);
        canvas.translate(posX, posY);
        canvas.drawArc(
            Rect.fromCenter(
              center: center,
              width: length * 2 - 25,
              height: length * 2 - 25,
            ),
            cStartAngle,
            cSliceAngle,
            true,
            getFillPaint(sliceFillColors[index]));
        canvas.restore();
        if (isAnimationOver) {
          canvas.save();
          canvas.translate(
              getXPosition(
                  (length * 2 - 25) / 3, cStartAngle + cSliceAngle / 2),
              getYPosition(
                  (length * 2 - 25) / 3, cStartAngle + cSliceAngle / 2));
          drawLabelText(canvas, chartValue, textSize, labelColor, center,
              (cStartAngle + cSliceAngle / 2) * (180 / pi) - startAngle);
          canvas.restore();
        }
      } else {
        canvas.drawArc(
            Rect.fromCenter(
              center: center,
              width: length * 2 - 35,
              height: length * 2 - 35,
            ),
            calculatedStartAngle,
            calculateArcLength(chartValue),
            true,
            getFillPaint(sliceFillColors[index]));
        if (isAnimationOver) {
          canvas.save();
          canvas.translate(
              getXPosition((length * 2 - 35) / 3,
                  calculatedStartAngle + calculateArcLength(chartValue) / 2),
              getYPosition((length * 2 - 35) / 3,
                  calculatedStartAngle + calculateArcLength(chartValue) / 2));
          drawLabelText(
              canvas,
              chartValue,
              textSize,
              labelColor,
              center,
              (calculatedStartAngle + calculateArcLength(chartValue) / 2) *
                      (180 / pi) -
                  startAngle);
          canvas.restore();
        }
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

  static void drawLabelText(Canvas canvas, double value, double textSize,
      Color labelColor, Offset center, double angle) {
    var textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
        text: "$value%",
        style: TextStyle(color: labelColor, fontSize: textSize));
    textPainter.textAlign = TextAlign.center;

    textPainter.layout();
    //top-left
    if (angle > 180 && angle < 270) {
      textPainter.paint(
          canvas,
          center.translate(-(textPainter.size.width + LABEL_X_PADDING) / 2,
              -LABEL_Y_PADDING));
    }
    //bottom-right
    else if (angle > 0 && angle < 90) {
      textPainter.paint(canvas,
          center.translate(-textPainter.size.width / 2, -LABEL_Y_PADDING / 2));
    }
    //top-right
    else if (angle > 270 && angle < 360) {
      textPainter.paint(
          canvas,
          center.translate(-textPainter.size.width / 2,
              -textPainter.size.height + LABEL_Y_PADDING));
    }
    //bottom-left
    else if (angle > 90 && angle < 180) {
      textPainter.paint(canvas,
          center.translate(-textPainter.size.width / 2, -LABEL_Y_PADDING / 2));
    }
    //top-center
    else if (angle == 270) {
      textPainter.paint(
          canvas,
          center.translate(-(textPainter.size.width / 2),
              -(textPainter.size.height + LABEL_Y_PADDING / 2)));
    }
    //bottom-center
    else if (angle == 90) {
      textPainter.paint(canvas,
          center.translate(-(textPainter.size.width / 2), LABEL_Y_PADDING));
    }
    //right-center
    else if (angle == 0 || angle == 360) {
      textPainter.paint(canvas,
          center.translate(LABEL_X_PADDING, -(textPainter.size.height / 2)));
    }
    //left-center
    else if (angle == 180) {
      textPainter.paint(
          canvas,
          center.translate(
              -(textPainter.size.width), -(textPainter.size.height / 2)));
    }
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

  static double getXPosition(double radius, double angle) =>
      radius * cos(angle);

  static double getYPosition(double radius, double angle) =>
      radius * sin(angle);
}
