import 'package:flutter/material.dart';
import 'package:multi_charts/src/radar_chart/utils/painters/radar_chart_painter.dart';

/// A chart which plots the values in the form of a spider web or radar. It takes the
/// @required[values] parameter which provides the data points `(minimum 3 values are required)` and @required[maxValue]
/// which defines the scale of the graph. E.g. The chart contains five levels, if
/// [maxValue]=10, then each level will have the value '2'.
///
/// The other parameters are optional which define different behaviours for the chart like:
/// [labels] which will be shown in the graph, if not provided, will default to the value
/// of data points. If provided, it's length should be same as that of values
///
/// [size] which defines the canvas area defaults to Size.infinite and is constrained by
/// the parent widget.
///
/// [fillColor] defines the background color of the plotted graph, if not provided,
/// defaults to [Colors.black26].
///
/// [strokeColor] defines the color of the chart outlines, defaults to [Colors.black87].
///
/// [labelColor] defines the color of the chart labels, defaults to [Colors.black].
///
/// [maxHeight] and [maxWidth] defines the maximum width and height of the chart when
/// no parent contraints are applied, otherwise ignored.
///
/// [textScaleFactor] defines the factor by which the label's textSize increases with
/// respect to the average of width and height of the enclosing parent widget,
/// if not provided defaults to 0.04
///
/// [labelWidth] defines the maximum width of the labels, if not provided, defaults to
/// internally calculated values based on the size of the chart.
///
/// [maxLinesForLabels] defines the maximum lines for the label's text, if not provided,
/// defaults to the hundredth part of the container height of the parent container.
/// E.g. if height of the parent is 200, the [maxLinesForLabels]=2
///
/// [animate] defines the animation toggle, if true, the chart will animate, else not.
/// Defaults to true.
///
/// [animationDuration] defines the duration of the animation for the graph. If not provided,
/// defaults to 1500 milliseconds.
///
/// [curve] defines the animation's progress in a non-linear fashion.
///
/// [chartRadiusFactor] defines the factor by which the chart radius increases with respect
/// to width or height (whatever is minimum). If not provided, defaults to 0.8 (80%)
class RadarChart extends StatefulWidget {
  final List<double> values;
  final List<String> labels;
  final double maxValue;
  final Size size;
  final Color fillColor;
  final Color strokeColor;
  final Color labelColor;
  final double maxWidth;
  final double maxHeight;
  final double textScaleFactor;
  final double labelWidth;
  final int maxLinesForLabels;
  final bool animate;
  final Duration animationDuration;
  final Curve curve;
  final double chartRadiusFactor;

  /// Creates a chart which plots the values in the form of a spider web or radar.
  ///
  /// It takes the @required `values` parameter which provides the data points (`minimum 3 values` are required) and @required `maxValue`
  /// which defines the scale of the graph. E.g. The chart contains five levels, if
  /// `maxValue=10`, then each level will have the value '2'.
  RadarChart(
      {Key key,
      @required this.values,
      this.labels,
      @required this.maxValue,
      this.size = Size.infinite,
      this.fillColor = Colors.black26,
      this.strokeColor = Colors.black87,
      this.labelColor = Colors.black,
      this.maxWidth = 200,
      this.maxHeight = 200,
      this.textScaleFactor = 0.04,
      this.labelWidth,
      this.maxLinesForLabels,
      this.animate = true,
      this.animationDuration = const Duration(milliseconds: 1500),
      this.curve = Curves.easeIn,
      this.chartRadiusFactor = 0.8});

  @override
  _RadarChartState createState() => _RadarChartState();
}

class _RadarChartState extends State<RadarChart> with TickerProviderStateMixin {
  AnimationController _dataAnimationController;
  Animation<double> _dataAnimation;
  AnimationController _outlineAnimationController;
  Animation<double> _outlineAnimation;
  double dataAnimationPercent = 0;
  double outlineAnimationPercent = 0;
  Animation curve;

  @override
  void initState() {
    super.initState();
    if (widget.values.any((value) => value > widget.maxValue)) {
      throw ArgumentError("All values of graph should be less than maxValue");
    }
    if (widget.values.length < 3) {
      throw ArgumentError("Minimum 3 values are required for Radar chart");
    }
    if (widget.labels != null && widget.values.length != widget.labels.length) {
      throw ArgumentError("values and labels should have same size");
    }
    _dataAnimationController = AnimationController(
        vsync: this,
        duration: widget.animate
            ? widget.animationDuration
            : Duration(milliseconds: 1))
      ..forward();
    _outlineAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.animate ? 500 : 1))
      ..forward();
    curve =
        CurvedAnimation(parent: _dataAnimationController, curve: widget.curve);
  }

  @override
  void dispose() {
    _dataAnimationController.dispose();
    _outlineAnimationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(RadarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.values.any((value) => value > widget.maxValue)) {
      _dataAnimationController.reset();
      _outlineAnimationController.reset();
      throw ArgumentError("All values of graph should be less than maxValue");
    } else if (widget.values.length < 3) {
      throw ArgumentError("Minimum 3 values are required for Radar chart");
    } else if (widget.labels != null &&
        widget.values.length != widget.labels.length) {
      throw ArgumentError("values and labels should have same size");
    } else if (widget.animate) {
      if (oldWidget.animationDuration != widget.animationDuration) {
        _dataAnimationController.duration = widget.animationDuration;
        _outlineAnimationController.duration = Duration(milliseconds: 500);
      }
      if (oldWidget.curve != widget.curve) {
        curve = CurvedAnimation(
            parent: _dataAnimationController, curve: widget.curve);
      }
      setState(() {
        _dataAnimationController
          ..reset()
          ..forward();
        _outlineAnimationController
          ..reset()
          ..forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _dataAnimation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {
          dataAnimationPercent = _dataAnimation.value;
        });
      });
    _outlineAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_outlineAnimationController)
          ..addListener(() {
            setState(() {
              outlineAnimationPercent = _outlineAnimation.value;
            });
          });
    return LimitedBox(
      maxWidth: widget.maxWidth,
      maxHeight: widget.maxHeight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomPaint(
          painter: RadarChartPainter(
              widget.values,
              widget.labels,
              widget.maxValue,
              widget.fillColor,
              widget.strokeColor,
              widget.labelColor,
              widget.textScaleFactor,
              widget.labelWidth,
              widget.maxLinesForLabels,
              widget.animate ? dataAnimationPercent : 1.0,
              widget.animate ? outlineAnimationPercent : 1.0,
              widget.chartRadiusFactor),
          size: widget.size,
        ),
      ),
    );
  }
}
