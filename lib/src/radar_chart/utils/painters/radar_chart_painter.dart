import 'dart:math' show pi, cos, sin;

import 'package:flutter/material.dart';
import 'package:multi_charts/src/radar_chart/utils/paint_utils.dart';

/// Custom Painter class for drawing the chart. Depends on various parameters like
/// [RadarChart.values], [RadarChart.labels], [RadarChart.maxValue], [RadarChart.fillColor],
/// [RadarChart.strokeColor], [RadarChart.textScaleFactor], [RadarChart.labelWidth],
/// [RadarChart.maxLinesForLabels].
///
/// It also has [dataAnimationPercent] and [outlineAnimationPercent] which defines the
/// animation of the chart data and outlines.
class RadarChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final double maxValue;
  final Color fillColor;
  final Color strokeColor;
  final double textScaleFactor;
  final double labelWidth;
  final int maxLinesForLabels;
  final double dataAnimationPercent;
  final double outlineAnimationPercent;

  RadarChartPainter(
      this.values,
      this.labels,
      this.maxValue,
      this.fillColor,
      this.strokeColor,
      this.textScaleFactor,
      this.labelWidth,
      this.maxLinesForLabels,
      this.dataAnimationPercent,
      this.outlineAnimationPercent);

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2.0, size.height / 2.0);
    double angle = (2 * pi) / values.length;
    var valuePoints = List<Offset>();
    for (var i = 0; i < values.length; i++) {
      var radiusFactor = (values[i] / maxValue) * center.dy / 2;
      var x = dataAnimationPercent * radiusFactor * cos(angle * i - pi / 2);
      var y = dataAnimationPercent * radiusFactor * sin(angle * i - pi / 2);

      valuePoints.add(Offset(x, y) + center);
    }

    var outerPoints = PaintUtils.drawChartOutline(canvas, center, angle,
        strokeColor, maxValue, values.length, outlineAnimationPercent);
    PaintUtils.drawGraphData(canvas, valuePoints, fillColor, strokeColor);
    PaintUtils.drawLabels(
        canvas,
        center,
        labels ?? values.map((v) => v.toString()).toList(),
        outerPoints,
        PaintUtils.getTextSize(size, textScaleFactor),
        labelWidth ?? PaintUtils.getDefaultLabelWidth(size, center, angle),
        maxLinesForLabels ?? PaintUtils.getDefaultMaxLinesForLabels(size));
  }

  @override
  bool shouldRepaint(RadarChartPainter oldDelegate) {
    return oldDelegate.dataAnimationPercent != dataAnimationPercent;
  }
}
