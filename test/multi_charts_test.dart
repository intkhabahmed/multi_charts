import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:multi_charts/src/common/common_paint_utils.dart';

void main() {
  test('calculates text size', () {
    double textSize = CommonPaintUtils.getTextSize(Size(200, 200), 0.04);
    expect(textSize, 8.0);
  });

  test('calculates label width', () {
    double labelWidth = CommonPaintUtils.getDefaultLabelWidth(
        Size(200, 200), Offset(100, 100), 1.047);
    expect(labelWidth, 52.52760331073994);
  });

  test('calculate max lines for labels', () {
    int maxLines = CommonPaintUtils.getDefaultMaxLinesForLabels(Size(200, 200));
    expect(maxLines, 2);
  });
}
