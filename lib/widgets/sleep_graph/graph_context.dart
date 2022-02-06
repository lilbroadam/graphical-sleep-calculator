import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class GraphContext {
  // [size] represents the size of the graph, not the size of the widget.
  // [size.width] represents the furthest x coordinate that the user has 
  // horizontally scrolled to and increases whenever the user scrolls further
  // right than they have previously.
  Size size = Size(0, 0);

  // The current view pane the user is viewing (i.e. a subset of [size]).
  // [viewPane.dx] represents the left side of the view pane.
  Offset viewPane = Offset(0, 0); // Coordinate of the view pane

  get minX => 0.0;
  get maxX => size.width;
  get minY => 0.0;
  get maxY => size.height;

  double sleepCycleMinX = 25.0;
  double sleepCycleMaxX;
  double sleepCycleMinY = 125.0;
  double sleepCycleMaxY = 275.0;
  double sleepCycleWidth = 120.0;
  double sleepCycleHeight; // 150.0 // 200
  int sleepCycleMinutes = 90;

  double sleepSentinelX;
  double wakeSentinelX;

  ValueNotifier<DateTime> sleepTimeNotifier;
  ValueNotifier<DateTime> wakeTimeNotifier;

  GraphContext() {
    sleepCycleHeight = sleepCycleMaxY - sleepCycleMinY;
  }

  void resize(Size size) {
    double width = max(this.size.width, viewPane.dx + size.width);
    this.size = Size(width, size.height);

    sleepCycleMaxX = size.width; // TODO is this necessary?
  }

  // Shift [canvas] to show what is in the current viewPane and clip it to 
  // prevent it from painting over other widgets.
  void applyViewPane(Canvas canvas, Size widgetSize) {
    canvas.clipRect(Rect.fromLTWH(0, 0, widgetSize.width, widgetSize.height));
    canvas.translate(-1 * this.viewPane.dx, 0);
  }

  /// Returns a sleep cycle Path that is at least maxX wide.
  Path getFullSleepCyclePath() {
    Path sleepCyclePath = Path();
    for (int i = 0; i < (maxX - minX) / sleepCycleWidth; i++) {
      Path p = getScaledSleepCyclePath();
      Offset o = Offset(sleepCycleMinX + i * sleepCycleWidth, sleepCycleMinY);
      sleepCyclePath.extendWithPath(p, o);
    }

    return sleepCyclePath;
  }

  Iterable<Path> getSleepCyclePath() sync* {
    // TODO IMPLEMENTME
  }

  /// Return a sleep cycle Path scaled to the proper width and height
  Path getScaledSleepCyclePath() {
    Float64List scaleMatrix = Float64List.fromList([
      sleepCycleWidth , 0.0               , 0.0     , 0.0,
      0.0             , sleepCycleHeight  , 0.0     , 0.0,
      0.0             , 0.0               , 1.0     , 0.0,
      0.0             , 0.0               , 0.0     , 1.0,
    ]);

    return getIdentitySleepCyclePath().transform(scaleMatrix);
  }

  /// Return an unscaled, unshifted sleep cycle Path of size 1x1 at (0, 0)
  Path getIdentitySleepCyclePath() {
    // The control points for the first quadrant of a 16x10 sleep cycle
    // in percentage of sleep cycle width and height
    const double OUTER_CONTROL_X = 2.5 / 16; // 0.15625
    const double OUTER_CONTROL_Y = 0.0 / 10; // 0.0
    const double INNER_CONTROL_X = 4.0 / 16; // 0.25
    const double INNER_CONTROL_Y = 2.5 / 10; // 0.25

    const double X_MAX = 1.0;
    const double Y_MAX = 1.0;
    Path sleepCyclePath = Path();
    sleepCyclePath.moveTo(0, 0);
    sleepCyclePath.cubicTo(
      (0/4) * X_MAX + OUTER_CONTROL_X, (0/2) * Y_MAX + OUTER_CONTROL_Y,
      (0/4) * X_MAX + INNER_CONTROL_X, (0/2) * Y_MAX + INNER_CONTROL_Y,
      (1/4) * X_MAX                  , (1/2) * Y_MAX);
    sleepCyclePath.cubicTo(
      (2/4) * X_MAX - INNER_CONTROL_X, (2/2) * Y_MAX - INNER_CONTROL_Y,
      (2/4) * X_MAX - OUTER_CONTROL_X, (2/2) * Y_MAX - OUTER_CONTROL_Y,
      (2/4) * X_MAX                  , (2/2) * Y_MAX);
    sleepCyclePath.cubicTo(
      (2/4) * X_MAX + OUTER_CONTROL_X, (2/2) * Y_MAX - OUTER_CONTROL_Y,
      (2/4) * X_MAX + INNER_CONTROL_X, (2/2) * Y_MAX - INNER_CONTROL_Y,
      (3/4) * X_MAX                  , (1/2) * Y_MAX);
    sleepCyclePath.cubicTo(
      (4/4) * X_MAX - INNER_CONTROL_X, (0/2) * Y_MAX + INNER_CONTROL_Y,
      (4/4) * X_MAX - OUTER_CONTROL_X, (0/2) * Y_MAX + OUTER_CONTROL_Y,
      (4/4) * X_MAX                  , (0/2) * Y_MAX);

    return sleepCyclePath;
  }

  Offset sleepCycleToOffset(double numCycles) {
    if (numCycles % 1 == 0) {
      return Offset(sleepCycleMinX + sleepCycleWidth * numCycles, sleepCycleMinY);
    } else {
      // TODO
    }
  }
}
