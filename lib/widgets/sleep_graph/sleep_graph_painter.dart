import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphsleepcalc/config/themes/theme_manager.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/hit_event/hit_event.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/paintable/paintable.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/paintable/sentinel.dart';

class SleepGraphPainter {

  Paint _backgroundPaint = Paint()
      ..color = ThemeManager.theme.backgroundColor
      ..style = PaintingStyle.fill;
  Paint _borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

  SleepSentinel _sleepSentinel;
  WakeSentinel _wakeSentinel;

  List<Paintable> _paintables = [];

  SleepGraphPainter() {
    _sleepSentinel = SleepSentinel();
    _wakeSentinel = WakeSentinel();

    _paintables.add(_sleepSentinel);
    _paintables.add(_wakeSentinel);
  }

  void paint(Canvas canvas, Size size) {
    _paintBackground(canvas, size);
    _paintBorder(canvas, size);

    for (Paintable paintable in _paintables) {
      paintable.paint(canvas, size);
    }
  }

  void _paintBackground(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _backgroundPaint
    );
  }

  void _paintBorder(Canvas canvas, Size size) {
    final strokeWidth = _borderPaint.strokeWidth;
    final halfStrokeWidth = strokeWidth / 2;

    // TODO corners aren't being drawn properly
    // Offset topLeft = Offset(0 + halfStrokeWidth, 0);
    // Offset topRight = Offset(size.width - halfStrokeWidth, 0);
    // Offset bottomLeft = Offset(0 + halfStrokeWidth, size.height);
    // Offset bottomRight = Offset(size.width - halfStrokeWidth, size.height);
    // canvas.drawLine(topLeft, topRight, _borderPaint);
    // canvas.drawLine(topRight, bottomRight, _borderPaint);
    // canvas.drawLine(bottomRight, bottomLeft, _borderPaint);
    // canvas.drawLine(bottomLeft, topLeft, _borderPaint);

    // TODO make sure this is being draw accurately
    canvas.drawRect(
      Rect.fromLTWH(
        0 + halfStrokeWidth,
        0,
        size.width - strokeWidth,
        size.height - strokeWidth),
      _borderPaint
    );
  }

  // TODO Caluclate the y value of the sleep graph at x
  double _sleepGraphYatX(double x) {
    return 125;
  }

  void onGestureEvent(GestureEvent event) {
    // print('Painter.onGestureEvent(${event.runtimeType})');
    for (Paintable paintable in _paintables) {
      if (paintable.hitTest(event)) {
        paintable.onGestureEvent(event);
      }
    }
  }
}
