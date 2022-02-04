import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/hit_event/hit_event.dart';
import 'package:graphsleepcalc/widgets/sleep_graph2/graph_context.dart';
import 'package:graphsleepcalc/widgets/sleep_graph2/paintable2/paintable2.dart';
import 'package:graphsleepcalc/widgets/sleep_graph2/paintable2/sentinel2.dart';

class SleepGraphPainter2 {
  GraphContext _graphContext;
  Paint _sleepCyclePaint;
  SleepSentinel2 _sleepSentinel;
  WakeSentinel2 _wakeSentinel;
  List<Paintable2> _paintables = [];

  SleepGraphPainter2(this._graphContext) {
    _sleepCyclePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;
    
    _sleepSentinel = SleepSentinel2(_graphContext);
    _wakeSentinel = WakeSentinel2(_graphContext);

    _paintables.add(_sleepSentinel);
    _paintables.add(_wakeSentinel);
  }

  void paint(Canvas canvas, Size size) {
    _graphContext.resize(size);

    _paintSleepCycle(canvas, size);
    _paintPaintables(canvas, size);
  }

  void _paintSleepCycle(Canvas canvas, Size size) {
    // TODO lazily extend path as user scrolls to the right
    canvas.drawPath(_graphContext.getFullSleepCyclePath(), _sleepCyclePaint);
  }

  void _paintPaintables(Canvas canvas, Size size) {
    for (Paintable2 p in _paintables) {
      p.paint(canvas, size);
    }
  }

  // Return true if painter detected a hit
  bool onGestureEvent(GestureEvent event) {
    bool hit = false;
    for (Paintable2 p in _paintables) {
      if (p.hitTest(event)) {
        hit = true;
        p.onGestureEvent(event);
      }
    }

    // TODO change return to if the event was handled by a paintable
    return hit;
  }
}
