import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphsleepcalc/config/themes/theme_manager.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/hit_event/hit_event.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/paintable/paintable.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/paintable/sentinel.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/paintable/sleep_sentinel.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/paintable/wake_sentinel.dart';

class Drawable {
  static List<Drawable> _drawables = [];

  String name;
  bool interactable = false; // TODO change to isInteractable
  double x, y, width, height;
  double hitBoxMargin = 10;
  
  Drawable(this.name, this.interactable, this.x, this.y, this.width, this.height);

  Offset get offset => Offset(x, y);
  Size get size => Size(width, height);

  bool isHit(Offset offset) {
    // TODO (x + width - offset.dx).abs()
    return (x - offset.dx).abs() < hitBoxMargin
        && (y - offset.dy).abs() < hitBoxMargin;
  }

  static add(Drawable drawable) {
    _drawables.add(drawable);
  }

  static get(String name) {
    for (Drawable drawable in _drawables) {
      if (drawable.name == name) {
        return drawable;
      }
    }
    return null;
  }

  // TODO add iterator
}

class SleepGraphPainter {

  Paint _backgroundPaint;
  Paint _borderPaint;

  // TODO these are temporary. Values should be set by constraints.
  static const double Y_MIN = 100;
  static const double Y_MAX = 300;

  List<Paintable> _paintables = [];

  SleepGraphPainter() {
    // Initialize paints
    _backgroundPaint = Paint()
      ..color = ThemeManager.theme.backgroundColor
      ..style = PaintingStyle.fill;
    _borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    _paintables.add(WakeSentinel());
    _paintables.add(SleepSentinel());
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
