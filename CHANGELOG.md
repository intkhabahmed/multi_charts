## [0.0.1] - 01/09/2019.

* Initial release - Supports Radar Chart with lots of customizations.

## [0.0.2] - 01/09/2019

* Fixed screenshots

## [0.1.0] - 21/09/2019

* Added **labelColor** parameter to give the desired color to labels, default value is **Colors.black**.
* Added a check for **values** (Minimum 3 values are required for plotting Radar Chart), else it will throw **ArgumentError**.
* Added a check for length of **values** and **labels**, both should be same.

## [0.1.1] - 13/11/2019

* Added **chartRadiusFactor** parameter to set the scaling of the chart with respect to width or height (whatever is minimum) of the parent widget, default value is **0.8 (80%)**.
* Fixed exception handling for null labels.
