import 'package:flutter/cupertino.dart';

import 'utils/legend_icon_shape.dart';
import 'utils/pie_chart_draw_utils.dart';

class PieChartLegendIconPainter extends CustomPainter {
  final Color legendIconFillColor;
  final double legendIconSize;
  final LegendIconShape legendIconShape;
  final double animationPercent;

  const PieChartLegendIconPainter(
    this.legendIconFillColor,
    this.legendIconSize,
    this.legendIconShape,
    this.animationPercent,
  );

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    PieChartDrawUtils.drawLegendShape(
      canvas,
      center,
      legendIconSize * animationPercent,
      legendIconShape,
      legendIconFillColor,
    );
  }

  @override
  bool shouldRepaint(PieChartLegendIconPainter oldDelegate) {
    return animationPercent != oldDelegate.animationPercent;
  }
}
