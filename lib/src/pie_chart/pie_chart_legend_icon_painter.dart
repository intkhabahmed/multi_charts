import 'package:flutter/cupertino.dart';

import 'utils/enums.dart';
import 'utils/paint_utils.dart';

class PieChartLegendIconPainter extends CustomPainter {
  final Color legendIconFillColor;
  final double legendIconSize;
  final LegendIconShape legendIconShape;

  const PieChartLegendIconPainter(
    this.legendIconFillColor,
    this.legendIconSize,
    this.legendIconShape,
  );

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    PaintUtils.drawLegend(
      canvas,
      center,
      legendIconSize,
      legendIconShape,
      legendIconFillColor,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
