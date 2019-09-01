import 'package:flutter/material.dart';
import 'package:multi_charts/multi_charts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radar Chart Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Radar Chart Example"),
        ),
        body: Center(
          child: Container(
            width: 450,
            height: 450,
            child: RadarChart(
              values: [1, 2, 4, 7, 9, 0, 6],
              labels: [
                "Label1",
                "Label2",
                "Label3",
                "Label4",
                "Label5",
                "Label6",
                "Label7",
              ],
              maxValue: 10,
              fillColor: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
