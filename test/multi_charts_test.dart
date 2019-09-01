import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:multi_charts/src/radar_chart/utils/paint_utils.dart';

void main() {
  test('calculates text size', () {
    double textSize = PaintUtils.getTextSize(Size(200, 200), 0.04);
    expect(textSize, 8.0);
  });

  test('calculates label width', () {
    double labelWidth = PaintUtils.getDefaultLabelWidth(
        Size(200, 200), Offset(100, 100), 1.047);
    expect(labelWidth, 52.52760331073994);
  });

  test('calculate max lines for labels', () {
    int maxLines = PaintUtils.getDefaultMaxLinesForLabels(Size(200, 200));
    expect(maxLines, 2);
  });
}
