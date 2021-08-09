import 'dart:core';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class SleepCycleGraph extends StatelessWidget {
  final double pxWidth;
  final double pxHeight;
  static const double _minXAxis = 0; // Each unit of x is an hour
  static const double _maxXAxis = 10;
  static const double _minYAxis = 0;
  static const double _maxYAxis = 20;
  static const double _sleepCycleAmplitude = (_maxYAxis - _minYAxis) * 0.25;
  static const double _sleepCycleLength = 1.5;

  SleepCycleGraph({this.pxWidth, this.pxHeight});

  VerticalLine drawVerticalLine(double xPos) {
    return VerticalLine(
      x: xPos,
      strokeWidth: 0.5,
      // label: VerticalLineLabel(
      //   show: true,
      //   // style: TextStyle()
      //   alignment: Alignment.bottomCenter,
      // ),
    );
  }

  bool showSleepCycleDot(FlSpot spot, LineChartBarData data) {
    // TODO IMPLEMENTME
    return false;
  }

  LineChartBarData drawSleepCycleGraph() {
    List<FlSpot> sleepCycleSpots = [];
    const double periodInterval = _sleepCycleLength / 16;
    for (double x = _minXAxis; x <= _maxXAxis; x += periodInterval) {
      // y = amplitude * cos(period * x + phaseShift) + verticalShift
      double graphPeriod = (2 * pi) / _sleepCycleLength;
      double y = _sleepCycleAmplitude * cos(graphPeriod * x) +
          0.5 * (_maxYAxis - _minYAxis);
      sleepCycleSpots.add(FlSpot(x, y));
    }

    return LineChartBarData(
      belowBarData: BarAreaData(
        show: true,
        colors: [Colors.blue].map((color) => color.withOpacity(0.3)).toList(),
      ),
      dotData: FlDotData(
        checkToShowDot: (dot, chart) => showSleepCycleDot(dot, chart),
      ),
      isCurved: true,
      spots: sleepCycleSpots,
    );
  }

  String xAxisToTime(double xAxisIndex) {
    var now = DateTime.now();
    var then = now.add(Duration(
      hours: xAxisIndex.toInt(),
      minutes: (xAxisIndex % 1 * 60).toInt(),
    ));
    return DateFormat.jm().format(then); // hh:mm a
  }

  String yAxisToAwakeLevel(double yAxisIndex) {
    double midYAxis = (_maxYAxis - _minYAxis) / 2;
    if (yAxisIndex == midYAxis + _sleepCycleAmplitude) {
      return 'Awake';
    } else if (yAxisIndex == midYAxis) {
      return 'Sleep';
    } else if (yAxisIndex == midYAxis - _sleepCycleAmplitude) {
      return 'Deep sleep';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) => InteractiveViewer(
        constrained: false,
        scaleEnabled: false,
        child: Container(
          width: pxWidth,
          height: pxHeight,
          child: Padding(
              padding: const EdgeInsets.only(top: 22.0, right: 20, left: 15),
              child: LineChart(
                LineChartData(
                  minX: _minXAxis,
                  maxX: _maxXAxis,
                  minY: _minYAxis,
                  maxY: _maxYAxis,
                  // showingTooltipIndicators: ,
                  lineBarsData: [
                    drawSleepCycleGraph(),
                  ],
                  extraLinesData: ExtraLinesData(verticalLines: [
                    drawVerticalLine(1.5),
                    drawVerticalLine(3),
                  ]),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      showTitles: true,
                      interval: _sleepCycleLength * 0.5,
                      // getTextStyles: // TODO
                      getTitles: (value) => xAxisToTime(value),
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTitles: (value) => yAxisToAwakeLevel(value),
                      reservedSize: 30,
                      // getTextStyles: // TODO
                    ),
                  ),
                ),
              )),
        ),
      );
}
