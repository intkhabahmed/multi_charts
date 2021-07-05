import 'package:flutter/material.dart';
import 'package:multi_charts/src/radar_chart/utils/painters/radar_chart_painter.dart';

/// A chart type which plots the values in the form of a spider web or radar.
///
/// It takes the `required` [values] parameter which provides the data points `(minimum 3 values are required)`
/// and `required` [maxValue] which defines the scale of the graph. E.g. The chart contains five
/// levels, if [maxValue] `= 10`, then each level will have the value `2`.
///
/// The other parameters are optional which define different behaviors for the chart like:
///
/// [labels] which will be shown in the graph, if not provided, will default to the value
/// of data points. If provided, it's length should be same as that of values.
///
/// [size] which defines the canvas area defaults to [Size.infinite] and is constrained by
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
/// no parent constraints are applied, otherwise ignored.
///
/// [textScaleFactor] defines the factor by which the label's textSize increases with
/// respect to the average of width and height of the enclosing parent widget,
/// if not provided defaults to `0.04`.
///
/// [labelWidth] defines the maximum width of the labels, if not provided, defaults to
/// internally calculated value based on the size of the chart.
///
/// [maxLinesForLabels] defines the maximum lines for the label's text, if not provided,
/// defaults to the hundredth part of the container height of the parent container.
/// E.g. if height of the parent is 200, the `[maxLinesForLabels] = 2`
///
/// [animate] defines the animation toggle, if true, the chart will animate, else not.
/// Defaults to `true`.
///
/// [animationDuration] defines the duration of the animation for the graph.
/// If not provided, defaults to `1500 milliseconds`.
///
/// [curve] defines the animation's progress style in a non-linear fashion.
///
/// [chartRadiusFactor] defines the factor by which the chart radius increases with respect
/// to width or height (whatever is minimum). If not provided, defaults to `0.8 (80%)`.
class RadarChart extends StatefulWidget {
  /// Data points of the graph
  final List<double> values;

  /// Provides naming for the data points
  ///
  /// If not provided, it will default to the value of data points.
  /// If provided, it's length should be same as that of values
  final List<String>? labels;

  /// Defines the scale of the graph
  ///
  /// E.g. The chart contains five levels,
  /// if [maxValue] `= 10`, then each level will have the value `2`.
  final double maxValue;

  /// Defines the size of the canvas
  ///
  /// The canvas area defaults to [Size.infinite] and is constrained by
  /// the parent widget.
  final Size size;

  /// Defines the background color of the plotted graph
  ///
  /// If not provided, it defaults to [Colors.black26].
  final Color fillColor;

  /// Defines the alpha of background color of the plotted graph
  ///
  /// If not provided, it defaults to `50`.
  final int fillAlpha;

  /// Defines the color of the chart outlines
  ///
  /// Defaults to [Colors.black87]
  final Color strokeColor;

  /// Defines the color of the chart labels
  ///
  /// Defaults to [Colors.black]
  final Color labelColor;

  /// Defines the maximum width of the chart
  ///
  /// If parent constraints are applied, it is ignored
  final double maxWidth;

  /// Defines the maximum height of the chart
  ///
  /// If parent constraints are applied, it is ignored
  final double maxHeight;

  /// Percent factor of text size wrt to Height and Width
  ///
  /// the factor by which the label's textSize increases with
  /// respect to the average of width and height of the enclosing parent widget,
  /// if not provided defaults to `0.04`.
  final double textScaleFactor;

  /// Defines the maximum width of the labels
  ///
  /// If not provided, it defaults to internally calculated value
  /// based on the size of the chart.
  final double? labelWidth;

  /// Defines the maximum lines for the label's text
  ///
  /// If not provided, it defaults to the hundredth part of the height
  /// of the parent container. E.g. if height of the parent is 200,
  /// the `[maxLinesForLabels] = 2`
  final int? maxLinesForLabels;

  /// It is the animation toggle
  ///
  /// If true, the chart will animate, else not. It is `true` by default.
  final bool animate;

  /// Defines the duration of the animation for the graph.
  ///
  /// If not provided, defaults to `1500 milliseconds`.
  final Duration animationDuration;

  /// It defines the animation style
  ///
  /// The default value is `Curves.easeIn`
  final Curve curve;

  /// Percent factor to chart's radius wrt to width or height (min of both)
  ///
  /// Defines the factor by which the chart radius increases with respect
  /// to width or height (whatever is minimum). If not provided, defaults to `0.8 (80%)`.
  final double chartRadiusFactor;

  /// Creates a chart which plots the values in the form of a spider web or radar.
  ///
  /// It takes the @required `values` parameter which provides the data points (`minimum 3 values` are required) and @required `maxValue`
  /// which defines the scale of the graph. E.g. The chart contains five levels, if
  /// `maxValue=10`, then each level will have the value '2'.
  ///
  /// Example code:
  /// ```
  /// RadarChart(
  ///   values: [1, 2, 4, 7, 9, 0, 6],
  ///   labels: [
  ///     "Label1",
  ///     "Label2",
  ///     "Label3",
  ///     "Label4",
  ///     "Label5",
  ///     "Label6",
  ///     "Label7",
  ///   ],
  ///   maxValue: 10,
  ///   fillColor: Colors.blue,
  ///   chartRadiusFactor: 0.7,
  /// )
  /// ```
  RadarChart(
      {Key? key,
      required this.values,
      this.labels,
      required this.maxValue,
      this.size = Size.infinite,
      this.fillColor = Colors.black26,
      this.fillAlpha = 50,
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
  late AnimationController _dataAnimationController;
  late Animation<double> _dataAnimation;
  late AnimationController _outlineAnimationController;
  late Animation<double> _outlineAnimation;
  double dataAnimationPercent = 0;
  double outlineAnimationPercent = 0;
  late Animation curve;

  @override
  void initState() {
    super.initState();
    if (widget.values.any((value) => value > widget.maxValue)) {
      throw ArgumentError("All values of graph should be less than maxValue");
    }
    if (widget.values.length < 3) {
      throw ArgumentError("Minimum 3 values are required for Radar chart");
    }
    if (widget.labels != null &&
        widget.values.length != widget.labels!.length) {
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
        widget.values.length != widget.labels!.length) {
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
    _dataAnimation =
        Tween(begin: 0.0, end: 1.0).animate(curve as Animation<double>)
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
              widget.fillAlpha,
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
