import 'dart:core';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphsleepcalc/config/themes/theme_manager.dart';
import 'package:intl/intl.dart';

class SleepCycleGraph extends StatelessWidget {
  final double _pxWidth;
  final double _pxHeight;
  static const double _minXAxis = 0; // Each unit of x is an hour
  static const double _maxXAxis = 10;
  static const double _minYAxis = 0;
  static const double _maxYAxis = 20;
  static const double _sleepCycleAmplitude = (_maxYAxis - _minYAxis) * 0.25;
  static const double _sleepCycleLength = 1.5;
  static final Color _textColor = ThemeManager.theme.textColor;
  static final Color _gridColor = ThemeManager.theme.accentColor;
  static final List<Color> _graphColors = [ThemeManager.theme.accentColor];
  static final List<Color> _graphShadeColors = [ThemeManager.theme.accentColor]
      .map((color) => color.withOpacity(0.3))
      .toList();

  SleepCycleGraph({double pxWidth, double pxHeight})
      : _pxWidth = pxWidth,
        _pxHeight = pxHeight;

  VerticalLine drawVerticalLine(double xPos) {
    return VerticalLine(
      x: xPos,
      strokeWidth: 0.5,
      color: _gridColor,
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
      colors: _graphColors,
      isCurved: true,
      spots: sleepCycleSpots,
      belowBarData: BarAreaData(
        show: true,
        colors: _graphShadeColors,
      ),
      dotData: FlDotData(
        checkToShowDot: (dot, chart) => showSleepCycleDot(dot, chart),
      ),
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
  Widget build(BuildContext context) {
    TextStyle sideTitleTextStyle = TextStyle(
      fontSize: 11,
      color: _textColor,
    );

    return InteractiveViewer(
      constrained: false,
      scaleEnabled: false,
      child: Container(
        width: _pxWidth,
        height: _pxHeight,
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
                    getTextStyles: (value) => sideTitleTextStyle,
                  ),
                  leftTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitles: (value) => yAxisToAwakeLevel(value),
                    getTextStyles: (value) => sideTitleTextStyle,
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
