import 'package:flutter/material.dart';
import 'package:multi_charts/src/pie_chart/utils/paint_utils.dart';

import 'utils/enums.dart';

class PieChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final Color labelColor;
  List<Color> sliceFillColors;
  final double labelIconSize;
  final LabelIconShape labelIconShape;
  final double textScaleFactor;
  final bool separateFocusedValue;
  final SeparatedValue separatedValueType;
  final double startAngle;
  final bool randomStartAngle;

  PieChartPainter(
      this.values,
      this.labels,
      this.labelColor,
      this.sliceFillColors,
      this.labelIconSize,
      this.labelIconShape,
      this.textScaleFactor,
      this.separateFocusedValue,
      this.separatedValueType,
      this.startAngle,
      this.randomStartAngle);

  @override
  void paint(Canvas canvas, Size size) {
    Offset chartRegion = Offset(size.width * (0.6), 0);
    Offset chartCenter = Offset(chartRegion.dx / 2, size.height / 2);
    sliceFillColors = PaintUtils.drawPieChart(
        canvas,
        chartCenter,
        values,
        sliceFillColors,
        PaintUtils.getTextSize(size, textScaleFactor),
        separateFocusedValue,
        separatedValueType,
        startAngle,
        randomStartAngle);
    PaintUtils.drawLegend(canvas, labels, labelColor, chartRegion, sliceFillColors,
        textScaleFactor, labelIconShape);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
