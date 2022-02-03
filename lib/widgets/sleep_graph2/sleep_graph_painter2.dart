import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/hit_event/hit_event.dart';
import 'package:graphsleepcalc/widgets/sleep_graph2/graph_context.dart';
import 'package:graphsleepcalc/widgets/sleep_graph2/paintable2/paintable2.dart';
import 'package:graphsleepcalc/widgets/sleep_graph2/paintable2/sentinel2.dart';

class SleepGraphPainter2 {
  GraphContext graphContext;
  Paint _sleepCyclePaint;
  SleepSentinel2 _sleepSentinel;
  WakeSentinel2 _wakeSentinel;
  List<Paintable2> _paintables = [];

  SleepGraphPainter2() {
    graphContext = GraphContext();

    _sleepCyclePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;
    
    _sleepSentinel = SleepSentinel2(graphContext);
    _wakeSentinel = WakeSentinel2(graphContext);

    _paintables.add(_sleepSentinel);
    _paintables.add(_wakeSentinel);
  }

  void paint(Canvas canvas, Size size) {
    graphContext.resize(size);

    _paintSleepCycle(canvas, size);
    _paintPaintables(canvas, size);
  }

  void _paintSleepCycle(Canvas canvas, Size size) {
    canvas.drawPath(graphContext.getFullSleepCyclePath(), _sleepCyclePaint);
  }

  void _paintPaintables(Canvas canvas, Size size) {
    for (Paintable2 p in _paintables) {
      p.paint(canvas, size);
    }
  }

  void onGestureEvent(GestureEvent event) {
    for (Paintable2 p in _paintables) {
      if (p.hitTest(event)) {
        p.onGestureEvent(event);
      }
    }
  }
}
