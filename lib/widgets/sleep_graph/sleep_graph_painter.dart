import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphsleepcalc/config/themes/theme_manager.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/graph_context.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/hit_event/hit_event.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/paintable/paintable.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/paintable/sentinel.dart';

class SleepGraphPainter {
  GraphContext _graphContext;
  Paint _sleepCyclePaint;
  SleepSentinel _sleepSentinel;
  WakeSentinel _wakeSentinel;
  List<Paintable> _paintables = [];

  SleepGraphPainter(this._graphContext) {
    _sleepCyclePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;
    
    _sleepSentinel = SleepSentinel(_graphContext);
    _wakeSentinel = WakeSentinel(_graphContext);

    _paintables.add(_sleepSentinel);
    _paintables.add(_wakeSentinel);
  }

  void paint(Canvas canvas, Size size) {
    _graphContext.resize(size);

    _paintSleepCycle(canvas, size);
    _paintPaintables(canvas, size);
  }

  void _paintSleepCycle(Canvas canvas, Size size) {
    Color awakeColor = ThemeManager.theme.awakeColor;
    Color deepSleepColor = ThemeManager.theme.deepSleepColor;
    double colorStopMargin = ThemeManager.theme.colorStopMargin;

    _sleepCyclePaint.shader = ui.Gradient.linear(
      Offset(0, 0),
      Offset(0, size.height),
      [awakeColor, deepSleepColor],
      [0 + colorStopMargin, 1.0 - colorStopMargin]
    );

    // TODO lazily extend path as user scrolls to the right
    canvas.drawPath(_graphContext.getFullSleepCyclePath(), _sleepCyclePaint);
  }

  void _paintPaintables(Canvas canvas, Size size) {
    for (Paintable p in _paintables) {
      p.paint(canvas, size);
    }
  }

  // Return true if painter detected a hit
  bool onGestureEvent(GestureEvent event) {
    bool hit = false;
    for (Paintable p in _paintables) {
      if (p.hitTest(event)) {
        hit = true;
        p.onGestureEvent(event);
      }
    }

    // TODO change return to if the event was handled by a paintable
    return hit;
  }
}
