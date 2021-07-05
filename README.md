[![Build Status](https://travis-ci.com/intkhabahmed/multi_charts.svg?branch=master)](https://travis-ci.com/intkhabahmed/multi_charts)
[![pub package](https://img.shields.io/pub/v/multi_charts.svg)](https://pub.dartlang.org/packages/multi_charts)

# multi_charts

It is a library that provides different types of charts to plot data points. Currently it supports:  
* Radar Chart
* Pie Chart

It will support more types in the coming future.

## Radar Chart

 A chart which plots the values in the form of a spider web or radar. It takes the
 @required **values** parameter which provides the data points **(minimum 3 values are required)** and @required **maxValue** which defines the scale of the graph. E.g. The chart contains five levels, if **maxValue**=10, then each level will have the value **2**.

 The other parameters are optional which define different behaviours for the chart like:
 
 * **labels** - which will be shown in the graph, if not provided, will default to the value of data points. If provided, it's length should be same as that of values

 * **size** - which defines the canvas area defaults to **Size.infinite** and is constrained by the parent widget.

 * **fillColor** - defines the background color of the plotted graph, if not provided, 
 defaults to **Colors.black26**.

 * **strokeColor** - defines the color of the chart outlines, defaults to **Colors.black87**.

 * **labelColor** - defines the color of the chart labels, defaults to **Colors.black**.

 * **maxHeight** and **maxWidth** - defines the maximum width and height of the chart when
 no parent constraints are applied, otherwise ignored.

 * **textScaleFactor** - defines the factor by which the label's textSize should increase, 
 if not provided defaults to **0.04**

 * **labelWidth** - defines the maximum width of the labels, if not provided, defaults to
 internally calculated values based on the size of the chart.

 * **maxLinesForLabels** - defines the maximum lines for the label's text, if not provided, 
 defaults to the hundredth part of the container height of the parent container.
 E.g.if height of the parent is 200, the **maxLinesForLabels = 2**

 * **animate** - defines the animation toggle, if true, the chart will animate, else not.
 Defaults to **true**.

 * **animationDuration** - defines the duration (in milliseconds) of the animation for the graph. If not provided, defaults to **1500 milliseconds**.

 * **curve** - defines the animation's progress in a non-linear fashion.

 * **chartRadiusFactor** - defines the factor by which the chart radius increases with respect
 to width or height (whatever is minimum). If not provided, defaults to **0.8 (80%)**.

### Screenshots

<img src="https://drive.google.com/uc?export=view&id=1xBM5mTMdU9d49Qo2vrxsq4UmBk2cEaps" alt="Radar Chart Red" width="200" height="400"/>
<img src="https://drive.google.com/uc?export=view&id=1aCshjCJjL5fjR-qxQI-yLFuNEHuxi5bG" alt="Radar Chart Blue" width="200" height="400"/>

## Pie Chart

A chart type which plots the values in the form of a pie with different slices representing
different values. It takes the @required **values** parameter which provides the data to plot
the graph.

The other parameters are optional which define different behaviors for the chart like:

* **labels** - which will be shown in the graph, if not provided, will default to the value of data points. If provided, it's length should be same as that of values

* **size** which defines the canvas area defaults to **Size.infinite** and is constrained by the parent widget.

* **sliceFillColors** defines the background color of each slice of the graph, if not provided, random colors will be generated.

* **maxHeight** and **maxWidth** defines the maximum width and height of the chart when no parent constraints are applied, otherwise ignored.

* **labelColor** defines the color of the chart values, defaults to **Colors.black87**.

* **legendTextColor** defines the color of the chart legend text, defaults to **Colors.black**.

* **legendPosition** defines the position of the chart legend in the layout. It can either be

**LegendPosition.Left**, **LegendPosition.Top**, **LegendPosition.Right** or **LegendPosition.Bottom**. The default position is **LegendPosition.Right**.

* **legendIconSize** defines the size of the legend icons. The default size value is **10.0**.

* **legendTextSize** defines the the text size of the legend labels. The default text size is **16.0**.

* **legendItemPadding** defines the padding around and in between the legend row items. The default padding is **8.0**.

* **legendIconShape** defines the shape of the legend icons. It can either be **LegendIconShape.Circle** or **LegendIconShape.Square**. The default shape is **LegendIconShape.Square**.

* **textScaleFactor** defines the factor by which the label's textSize increases with respect to the average of width and height of the enclosing parent widget, if not provided defaults to **0.04**.

* **animate** defines the animation toggle, if true, the chart will animate, else not. Defaults to **true**.

* **animationDuration** defines the duration (in milliseconds) of the animation for the graph. If not provided, defaults to **1500 milliseconds**.

* **curve** defines the animation's progress in a non-linear fashion.

* **separateFocusedValue** defines whether we want to highlight focused value (of type: **SeparatedValue.Max** or **SeparatedValue.Min**) as a slice separated from the chart. By default, it is set to **false**.

* **separatedValueType** defines which value slice to show as separated. It can be either **SeparatedValue.Max** or **SeparatedValue.Min**. The default value is **SeparatedValue.Max**.

* **startAngle** defines the start angle (in degrees) of the chart's radial position. The default value is **180**.

* **showLegend** defines whether to show the chart legend or not. By default, it is set to **true**.

### Screenshots

<img src="https://drive.google.com/uc?export=view&id=1s-DCVNzt82I5ESy3cnmsStqAVWtl3YSl" alt="Radar Chart Red" width="200" height="400"/>
<img src="https://drive.google.com/uc?export=view&id=1rDF05gTjvx8AeMcsDxZ4MBbDugmNpb9_" alt="Radar Chart Blue" width="200" height="400"/>
