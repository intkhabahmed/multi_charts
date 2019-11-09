import 'package:flutter/material.dart';
import 'package:multi_charts/src/pie_chart/pie_chart_painter.dart';

import 'utils/enums.dart';

class PieChart extends StatefulWidget {
  final List<double> values;
  final List<String> labels;
  final Size size;
  final List<Color> sliceFillColors;
  final double maxWidth;
  final double maxHeight;
  final Color labelColor;
  final double labelIconSize;
  final LabelIconShape labelIconShape;
  final double textScaleFactor;
  final bool animate;
  final Duration animationDuration;
  final Curve curve;
  final bool separateFocusedValue;
  final SeparatedValue separatedValueType;
  final double startAngle;
  final bool randomStartAngle;

  const PieChart(
      {Key key,
      this.values,
      this.labels,
      this.size = Size.infinite,
      this.sliceFillColors,
      this.maxWidth = 200,
      this.maxHeight = 200,
      this.labelColor = Colors.black,
      this.labelIconSize,
      this.labelIconShape = LabelIconShape.Square,
      this.textScaleFactor = 0.04,
      this.animate = true,
      this.animationDuration = const Duration(milliseconds: 1500),
      this.curve = Curves.easeIn,
      this.separateFocusedValue = false,
      this.separatedValueType = SeparatedValue.Max,
      this.startAngle = 180,
      this.randomStartAngle = false});

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxWidth: widget.maxWidth,
      maxHeight: widget.maxHeight,
      child: CustomPaint(
        painter: PieChartPainter(
            widget.values,
            widget.labels,
            widget.labelColor,
            widget.sliceFillColors,
            widget.labelIconSize,
            widget.labelIconShape,
            widget.textScaleFactor,
            widget.separateFocusedValue,
            widget.separatedValueType,
            widget.startAngle,
            widget.randomStartAngle),
        size: widget.size,
      ),
    );
  }
}
