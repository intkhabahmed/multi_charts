import 'package:flutter/material.dart';
import 'package:multi_charts/src/pie_chart/utils/paint_utils.dart';

import 'utils/legend_position.dart';
import 'utils/separated_value.dart';

class PieChartPainter extends CustomPainter {
  final List<double> values;
  final Color labelColor;
  List<Color> sliceFillColors;
  final double textScaleFactor;
  final bool separateFocusedValue;
  final SeparatedValue separatedValueType;
  final double startAngle;
  final LegendPosition legendPosition;
  final double dataAnimationPercent;

  PieChartPainter(
      this.values,
      this.labelColor,
      this.sliceFillColors,
      this.textScaleFactor,
      this.separateFocusedValue,
      this.separatedValueType,
      this.startAngle,
      this.legendPosition,
      this.dataAnimationPercent);

  @override
  void paint(Canvas canvas, Size size) {
    Offset chartCenter = Offset(size.width / 2, size.height / 2);
    PaintUtils.drawPieChart(
        canvas,
        chartCenter,
        values.map((v) => v * dataAnimationPercent).toList(),
        sliceFillColors,
        PaintUtils.getTextSize(size, textScaleFactor),
        separateFocusedValue,
        separatedValueType,
        startAngle,
        legendPosition,
        dataAnimationPercent == 1.0,
        labelColor);
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) {
    return dataAnimationPercent != oldDelegate.dataAnimationPercent;
  }
}
