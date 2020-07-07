import 'dart:math' show cos, pi, sin;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:multi_charts/src/common/common_paint_utils.dart';

/// Helper class to draw the different radar chart elements.
class RadarChartDrawUtils {
  /// Draws the labels at the given offset positions at the outside of the graph.
  static void drawLabels(
      Canvas canvas,
      Offset center,
      List<String> labels,
      List<Offset> labelPoints,
      double textSize,
      double labelWidth,
      int maxLinesForLabels,
      Color labelColor) {
    var textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (var i = 0; i < labelPoints.length; i++) {
      textPainter.text = TextSpan(
          text: labels[i],
          style: TextStyle(color: labelColor, fontSize: textSize));
      textPainter.maxLines = maxLinesForLabels;
      textPainter.textAlign = TextAlign.center;

      textPainter.layout(maxWidth: labelWidth);
      //top-left
      if (labelPoints[i].dx < center.dx && labelPoints[i].dy < center.dy) {
        textPainter.paint(
            canvas,
            labelPoints[i].translate(
                -(textPainter.size.width + CommonPaintUtils.LABEL_X_PADDING),
                -CommonPaintUtils.LABEL_Y_PADDING));
      }
      //bottom-right
      else if (labelPoints[i].dx > center.dx && labelPoints[i].dy > center.dy) {
        textPainter.paint(
            canvas,
            labelPoints[i].translate(CommonPaintUtils.LABEL_X_PADDING,
                -CommonPaintUtils.LABEL_Y_PADDING / 2));
      }
      //top-right
      else if (labelPoints[i].dx > center.dx && labelPoints[i].dy < center.dy) {
        textPainter.paint(
            canvas,
            labelPoints[i].translate(CommonPaintUtils.LABEL_X_PADDING,
                -textPainter.size.height / 2));
      }
      //bottom-left
      else if (labelPoints[i].dx < center.dx && labelPoints[i].dy > center.dy) {
        textPainter.paint(
            canvas,
            labelPoints[i].translate(
                -(textPainter.size.width +
                    CommonPaintUtils.LABEL_X_PADDING / 2),
                -CommonPaintUtils.LABEL_Y_PADDING / 2));
      }
      //top-center
      else if (labelPoints[i].dx == center.dx &&
          labelPoints[i].dy < center.dy) {
        textPainter.paint(
            canvas,
            labelPoints[i].translate(
                -(textPainter.size.width / 2),
                -(textPainter.size.height +
                    CommonPaintUtils.LABEL_Y_PADDING / 2)));
      }
      //bottom-center
      else if (labelPoints[i].dx == center.dx &&
          labelPoints[i].dy > center.dy) {
        textPainter.paint(
            canvas,
            labelPoints[i].translate(-(textPainter.size.width / 2),
                CommonPaintUtils.LABEL_Y_PADDING));
      }
      //right-center
      else if (labelPoints[i].dx > center.dx &&
          labelPoints[i].dy == center.dy) {
        textPainter.paint(
            canvas,
            labelPoints[i].translate(CommonPaintUtils.LABEL_X_PADDING,
                -(textPainter.size.height / 2)));
      }
      //left-center
      else if (labelPoints[i].dx < center.dx &&
          labelPoints[i].dy == center.dy) {
        textPainter.paint(
            canvas,
            labelPoints[i].translate(
                -(textPainter.size.width + CommonPaintUtils.LABEL_X_PADDING),
                -(textPainter.size.height / 2)));
      }
    }
  }

  /// Draws the outlines of the chart based on the [RadarChart.maxValue].
  static List<Offset> drawChartOutline(
      Canvas canvas,
      Offset center,
      double angle,
      Color strokeColor,
      double maxValue,
      int noOfPoints,
      double animationPercent,
      double chartRadius) {
    var boundaryPoints = List<Offset>();
    var outerPoints = List<Offset>();
    for (var i = 0; i < maxValue; i += maxValue ~/ 5) {
      boundaryPoints.clear();
      for (var j = 0; j < noOfPoints; j++) {
        var x = animationPercent * chartRadius * cos(angle * j - pi / 2);
        var y = animationPercent * chartRadius * sin(angle * j - pi / 2);
        x -= x * i / maxValue;
        y -= y * i / maxValue;
        boundaryPoints.add(Offset(x, y) + center);
        if (i == 0) {
          outerPoints.add(boundaryPoints[j]);
        }
        canvas.drawLine(center, boundaryPoints[j],
            CommonPaintUtils.getStrokePaint(strokeColor, 150, 0.3));
      }
      boundaryPoints.add(boundaryPoints[0]);
      canvas.drawPoints(PointMode.polygon, boundaryPoints,
          CommonPaintUtils.getStrokePaint(strokeColor, 150, 0.8));
    }
    canvas.drawCircle(
        center, 2.0, CommonPaintUtils.getFillPaint(strokeColor, alpha: 50));
    return outerPoints;
  }

  /// Draws the graph data for all the value points with the background color defined by
  /// [RadarChart.fillColor].
  static void drawGraphData(Canvas canvas, List<Offset> valuePoints,
      Color fillColor, Color strokeColor) {
    Path valuePath = Path()..addPolygon(valuePoints, true);
    canvas.drawPath(
        valuePath, CommonPaintUtils.getFillPaint(fillColor, alpha: 50));
    canvas.drawPath(
        valuePath, CommonPaintUtils.getStrokePaint(fillColor, 200, 1.5));
  }
}
