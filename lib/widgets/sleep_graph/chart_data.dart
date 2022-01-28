import 'package:flutter/material.dart';
import 'dart:typed_data';

class ChartData {
  double borderWidth;
  double timeLabelMargin;
  double sleepLabelMargin;

  double gridMinX;
  double gridMaxX;
  double gridMinY;
  double gridMaxY;

  double xAxisX;
  double xAxisYMin;
  double xAxisYMax;
  double yAxisY;
  double yAxisXMin;
  double yAxisXMax;

  ChartData ({
    this.borderWidth,
    this.timeLabelMargin,
    this.sleepLabelMargin,
  });

  void resize(Size size) {
    gridMinX = borderWidth;
    gridMaxX = size.width - borderWidth;
    gridMinY = borderWidth;
    gridMaxY = size.height - borderWidth;

    xAxisX = gridMinX + sleepLabelMargin + borderWidth;
    xAxisYMin = gridMinY;
    xAxisYMax = gridMaxY;
    yAxisY = gridMaxY - sleepLabelMargin - borderWidth;
    yAxisXMin = gridMinX;
    yAxisXMax = gridMaxX;
  }

  Path getSleepCyclePath([Path prefixPath]) {
    double xStart = 100.0;
    double yStart = 125.0;
    double sleepCycleWidth = 120.0;
    double sleepCycleHeight = 150.0; // 200

    // The control points for the first quadrant of a 16x10 sleep cycle
    // in percentage of sleep cycle width and height
    const double OUTER_CONTROL_X = 2.5 / 16; // 0.15625
    const double OUTER_CONTROL_Y = 0.0 / 10; // 0.0
    const double INNER_CONTROL_X = 4.0 / 16; // 0.25
    const double INNER_CONTROL_Y = 2.5 / 10; // 0.25

    Path remLevelPath = Path();
    remLevelPath.moveTo(xStart, yStart);

    // Plot a sleep cycle at (0, 0) of size 1x1
    const double X_MAX = 1.0;
    const double Y_MAX = 1.0;
    remLevelPath.moveTo(0, 0);
    remLevelPath.cubicTo(
      (0/4) * X_MAX + OUTER_CONTROL_X, (0/2) * Y_MAX + OUTER_CONTROL_Y,
      (0/4) * X_MAX + INNER_CONTROL_X, (0/2) * Y_MAX + INNER_CONTROL_Y,
      (1/4) * X_MAX                  , (1/2) * Y_MAX);
    remLevelPath.cubicTo(
      (2/4) * X_MAX - INNER_CONTROL_X, (2/2) * Y_MAX - INNER_CONTROL_Y,
      (2/4) * X_MAX - OUTER_CONTROL_X, (2/2) * Y_MAX - OUTER_CONTROL_Y,
      (2/4) * X_MAX                  , (2/2) * Y_MAX);
    remLevelPath.cubicTo(
      (2/4) * X_MAX + OUTER_CONTROL_X, (2/2) * Y_MAX - OUTER_CONTROL_Y,
      (2/4) * X_MAX + INNER_CONTROL_X, (2/2) * Y_MAX - INNER_CONTROL_Y,
      (3/4) * X_MAX                  , (1/2) * Y_MAX);
    remLevelPath.cubicTo(
      (4/4) * X_MAX - INNER_CONTROL_X, (0/2) * Y_MAX + INNER_CONTROL_Y,
      (4/4) * X_MAX - OUTER_CONTROL_X, (0/2) * Y_MAX + OUTER_CONTROL_Y,
      (4/4) * X_MAX                  , (0/2) * Y_MAX);

    // Scale sleep cycle path to proper width and height
    // and shift it to start at proper start position
    Float64List scaleMatrix = Float64List.fromList([
      sleepCycleWidth , 0.0               , 0.0     , 0.0,
      0.0             , sleepCycleHeight  , 0.0     , 0.0,
      0.0             , 0.0               , 1.0     , 0.0,
      0.0             , 0.0               , 0.0     , 1.0,
    ]);
    // return remLevelPath.transform(scaleMatrix).shift(Offset(xStart, yStart));

    if (prefixPath != null) {
      // prefixPath.addPath(path, Offset.zero);
      prefixPath.extendWithPath(remLevelPath, Offset(0, 0));
      return prefixPath;
    } else {
      return remLevelPath.transform(scaleMatrix).shift(Offset(xStart, yStart));
    }

    // hard coded
    // remLevelPath.cubicTo(
    //   xStart + 0.3125 * sleepCycleWidth, yStart,
    //   // xStart + 0.5 * sleepCycleWidth, yStart + 0.5 * 0.5 * sleepCycleHeight,
    //   // xStart + 0.5 * sleepCycleWidth, yStart + 0.25 * 0.5 * sleepCycleHeight,
    //   xStart + 0.5 * sleepCycleWidth, yStart + 0.25 * sleepCycleHeight,
    //   xStart + 0.5 * sleepCycleWidth, yStart + 0.5 * sleepCycleHeight);
    // remLevelPath.cubicTo(
    //   xStart + 0.5 * sleepCycleWidth, yStart + 0.75 * sleepCycleHeight,
    //   xStart + 0.6875 * sleepCycleWidth, yStart + 1 * sleepCycleHeight,
    //   xStart + 1 * sleepCycleWidth, yStart + 1 * sleepCycleHeight);
    // remLevelPath.cubicTo(
    //   xStart + 1.3125 * sleepCycleWidth, yStart + 1 * sleepCycleHeight,
    //   xStart + 1.5 * sleepCycleWidth, yStart + 0.75 * sleepCycleHeight,
    //   xStart + 1.5 * sleepCycleWidth, yStart + 0.5 * sleepCycleHeight);
    // remLevelPath.cubicTo(
    //   xStart + 1.5 * sleepCycleWidth, yStart + 0.25 * sleepCycleHeight,
    //   xStart + 1.6875 * sleepCycleWidth, yStart + 0 * sleepCycleHeight,
    //   xStart + 2 * sleepCycleWidth, yStart + 0 * sleepCycleHeight);
    // return remLevelPath;
  }

  // TODO Caluclate the y value of the sleep graph at hour x
  // double yAtX(double x) {}
}
