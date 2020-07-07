import 'dart:math' show cos, max, min, pi, sin;

import 'package:flutter/material.dart';
import 'package:multi_charts/src/common/common_paint_utils.dart';

import 'legend_icon_shape.dart';
import 'legend_position.dart';
import 'separated_value.dart';

/// Helper class to draw the different pie chart elements.
class PieChartDrawUtils {
  /// Draws the Pie Chart
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
        double cSliceAngle = CommonPaintUtils.calculateArcLength(chartValue);
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
            CommonPaintUtils.getFillPaint(sliceFillColors[index]));
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
            CommonPaintUtils.calculateArcLength(chartValue),
            true,
            CommonPaintUtils.getFillPaint(sliceFillColors[index]));
        if (isAnimationOver) {
          canvas.save();
          canvas.translate(
              getXPosition(
                  (length * 2 - 35) / 3,
                  calculatedStartAngle +
                      CommonPaintUtils.calculateArcLength(chartValue) / 2),
              getYPosition(
                  (length * 2 - 35) / 3,
                  calculatedStartAngle +
                      CommonPaintUtils.calculateArcLength(chartValue) / 2));
          drawLabelText(
              canvas,
              chartValue,
              textSize,
              labelColor,
              center,
              (calculatedStartAngle +
                          CommonPaintUtils.calculateArcLength(chartValue) / 2) *
                      (180 / pi) -
                  startAngle);
          canvas.restore();
        }
      }
      calculatedStartAngle = calculatedStartAngle +
          CommonPaintUtils.calculateArcLength(chartValue);
    });
    //canvas.drawCircle(center, center.dx / 2.5, CommonPaintUtils.getFillPaint(Colors.transparent)..blendMode=BlendMode.dstOut);
  }

  /// Draws Pie Chart Legend Shape
  static void drawLegendShape(
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
            CommonPaintUtils.getFillPaint(legendIconFillColor),
          )
        : canvas.drawRect(
            Rect.fromCenter(
              center: center,
              width: legendIconSize,
              height: legendIconSize,
            ),
            CommonPaintUtils.getFillPaint(legendIconFillColor));
  }

  /// Draws label text inside the Pie Chart
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
          center.translate(
              -(textPainter.size.width + CommonPaintUtils.LABEL_X_PADDING) / 2,
              -CommonPaintUtils.LABEL_Y_PADDING));
    }
    //bottom-right
    else if (angle > 0 && angle < 90) {
      textPainter.paint(
          canvas,
          center.translate(-textPainter.size.width / 2,
              -CommonPaintUtils.LABEL_Y_PADDING / 2));
    }
    //top-right
    else if (angle > 270 && angle < 360) {
      textPainter.paint(
          canvas,
          center.translate(-textPainter.size.width / 2,
              -textPainter.size.height + CommonPaintUtils.LABEL_Y_PADDING));
    }
    //bottom-left
    else if (angle > 90 && angle < 180) {
      textPainter.paint(
          canvas,
          center.translate(-textPainter.size.width / 2,
              -CommonPaintUtils.LABEL_Y_PADDING / 2));
    }
    //top-center
    else if (angle == 270) {
      textPainter.paint(
          canvas,
          center.translate(
              -(textPainter.size.width / 2),
              -(textPainter.size.height +
                  CommonPaintUtils.LABEL_Y_PADDING / 2)));
    }
    //bottom-center
    else if (angle == 90) {
      textPainter.paint(
          canvas,
          center.translate(
              -(textPainter.size.width / 2), CommonPaintUtils.LABEL_Y_PADDING));
    }
    //right-center
    else if (angle == 0 || angle == 360) {
      textPainter.paint(
          canvas,
          center.translate(CommonPaintUtils.LABEL_X_PADDING,
              -(textPainter.size.height / 2)));
    }
    //left-center
    else if (angle == 180) {
      textPainter.paint(
          canvas,
          center.translate(
              -(textPainter.size.width), -(textPainter.size.height / 2)));
    }
  }

  static double getXPosition(double radius, double angle) =>
      radius * cos(angle);

  static double getYPosition(double radius, double angle) =>
      radius * sin(angle);
}
