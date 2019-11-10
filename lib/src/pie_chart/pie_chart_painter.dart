import 'package:flutter/material.dart';
import 'package:multi_charts/src/pie_chart/utils/paint_utils.dart';

import 'utils/enums.dart';

class PieChartPainter extends CustomPainter {
  final List<double> values;
  final Color labelColor;
  List<Color> sliceFillColors;
  final double textScaleFactor;
  final bool separateFocusedValue;
  final SeparatedValue separatedValueType;
  final double startAngle;
  final bool randomStartAngle;

  PieChartPainter(
      this.values,
      this.labelColor,
      this.sliceFillColors,
      this.textScaleFactor,
      this.separateFocusedValue,
      this.separatedValueType,
      this.startAngle,
      this.randomStartAngle);

  @override
  void paint(Canvas canvas, Size size) {
    Offset chartCenter = Offset(size.width / 2, size.height / 2);
    PaintUtils.drawPieChart(
        canvas,
        chartCenter,
        values,
        sliceFillColors,
        PaintUtils.getTextSize(size, textScaleFactor),
        separateFocusedValue,
        separatedValueType,
        startAngle,
        randomStartAngle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
