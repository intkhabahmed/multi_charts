import 'package:flutter/material.dart';
import 'package:multi_charts/src/pie_chart/pie_chart_painter.dart';
import 'package:multi_charts/src/pie_chart/utils/paint_utils.dart';

import 'pie_chart_legend_icon_painter.dart';
import 'utils/legend_icon_shape.dart';
import 'utils/legend_position.dart';
import 'utils/separated_value.dart';

class PieChart extends StatefulWidget {
  final List<double> values;
  final List<String> labels;
  final Size size;
  final List<Color> sliceFillColors;
  final double maxWidth;
  final double maxHeight;
  final Color labelColor;
  final LegendPosition legendPosition;
  final double legendIconSize;
  final double legendTextSize;
  final EdgeInsetsGeometry legendItemPadding;
  final LegendIconShape legendIconShape;
  final double textScaleFactor;
  final bool animate;
  final Duration animationDuration;
  final Curve curve;
  final bool separateFocusedValue;
  final SeparatedValue separatedValueType;
  final double startAngle;

  const PieChart(
      {Key key,
      @required this.values,
      this.labels,
      this.size = Size.infinite,
      this.sliceFillColors,
      this.maxWidth = 200,
      this.maxHeight = 200,
      this.labelColor = Colors.black,
      this.legendPosition = LegendPosition.Right,
      this.legendIconSize = 10,
      this.legendTextSize = 16.0,
      this.legendItemPadding =
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      this.legendIconShape = LegendIconShape.Square,
      this.textScaleFactor = 0.04,
      this.animate = true,
      this.animationDuration = const Duration(milliseconds: 1500),
      this.curve = Curves.easeIn,
      this.separateFocusedValue = false,
      this.separatedValueType = SeparatedValue.Max,
      this.startAngle = 180});

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart>
    with SingleTickerProviderStateMixin {
  List<Color> _sliceFillColors;
  List<dynamic> _labels;
  AnimationController _controller;
  Animation<double> _animation;
  double _dataAnimationPercent = 0;
  Animation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _sliceFillColors = widget.sliceFillColors == null
        ? PaintUtils.getRandomColors(widget.labels?.length)
        : widget.sliceFillColors;
    _labels = widget.labels != null && widget.labels.length > 0
        ? widget.labels
        : widget.values.map((v) => "$v%").toList();
    _controller = AnimationController(
        vsync: this,
        duration: widget.animate
            ? widget.animationDuration
            : Duration(milliseconds: 1))
      ..forward();
    _curvedAnimation =
        CurvedAnimation(curve: widget.curve, parent: _controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PieChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.values.reduce((a, b) => a + b) > 100) {
      print("Sum ${widget.values.reduce((a, b) => a + b)}");
      throw ArgumentError(
          "The sum of all values should be less than or equal to 100");
    } else if (widget.labels != null &&
        widget.values?.length != widget.labels?.length) {
      throw ArgumentError("Values and Labels should have same size");
    }
    if (widget.labels != oldWidget.labels) {
      _labels = widget.labels != null && widget.labels.length > 0
          ? widget.labels
          : widget.values.map((v) => "$v%").toList();
    }
    if (widget.animate) {
      if (oldWidget.animationDuration != widget.animationDuration) {
        _controller.duration = widget.animationDuration;
      }
      if (oldWidget.curve != widget.curve) {
        _curvedAnimation =
            CurvedAnimation(parent: _controller, curve: widget.curve);
      }
      setState(() {
        _controller
          ..reset()
          ..forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxWidth: widget.maxWidth,
      maxHeight: widget.maxHeight,
      child: _getLayoutAsPerLegendPosition(widget.legendPosition),
    );
  }

  Widget _getLayoutAsPerLegendPosition(LegendPosition position) {
    switch (position) {
      case LegendPosition.Right:
        return Row(
          children: <Widget>[
            Flexible(
              flex: 3,
              child: _chartLayout(),
            ),
            Flexible(
              flex: 1,
              child: _legendLayout(Axis.vertical),
            ),
          ],
        );
      case LegendPosition.Left:
        return Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: _legendLayout(Axis.vertical),
            ),
            Flexible(
              flex: 3,
              child: _chartLayout(),
            ),
          ],
        );
      case LegendPosition.Top:
        return Column(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: _legendLayout(Axis.horizontal),
            ),
            Flexible(
              flex: 3,
              child: _chartLayout(),
            ),
          ],
        );
      case LegendPosition.Bottom:
        return Column(
          children: <Widget>[
            Flexible(
              flex: 3,
              child: _chartLayout(),
            ),
            Flexible(
              flex: 1,
              child: _legendLayout(Axis.horizontal),
            ),
          ],
        );
      default:
        return null;
    }
  }

  Widget _chartLayout() {
    _animation = Tween(begin: 0.0, end: 1.0).animate(_curvedAnimation)
      ..addListener(() {
        setState(() {
          _dataAnimationPercent = _animation.value;
        });
      });
    return CustomPaint(
      painter: PieChartPainter(
          widget.values,
          widget.labelColor,
          _sliceFillColors,
          widget.textScaleFactor,
          widget.separateFocusedValue,
          widget.separatedValueType,
          widget.startAngle,
          widget.legendPosition,
          widget.animate ? _dataAnimationPercent : 1.0),
      size: widget.size,
    );
  }

  Widget _legendLayout(Axis direction) {
    return ListView.builder(
      scrollDirection: direction,
      itemCount: _labels.length,
      itemBuilder: (context, index) => Padding(
        padding: widget.legendItemPadding,
        child: Row(
          children: <Widget>[
            CustomPaint(
              painter: PieChartLegendIconPainter(
                  _sliceFillColors[index],
                  widget.legendIconSize,
                  widget.legendIconShape,
                  _dataAnimationPercent),
              size: Size(widget.legendIconSize, widget.legendIconSize),
            ),
            direction == Axis.vertical
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        _labels[index],
                        style: TextStyle(
                            color: widget.labelColor,
                            fontSize: widget.legendTextSize),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      _labels[index],
                      style: TextStyle(
                          color: widget.labelColor,
                          fontSize: widget.legendTextSize),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
